import imaplib
import email
import datetime
from email.header import decode_header
import re
from django.template.loader import render_to_string
from django.core.mail import EmailMessage
from django.conf import settings
from datetime import datetime, timedelta
from dateutil.relativedelta import relativedelta
from django.db.models import Prefetch, Max
import django
from bs4 import BeautifulSoup
import telegram
from integrator.celery import app
from django.contrib.auth import get_user_model
from django.http import HttpResponse
from django.db.models import Subquery, OuterRef
User = get_user_model()

from applications.models import ApplicationModel, AppStatusModel, StatusModel, AppHistoryModel, ApplicationArchiveModel, EmailLastUID, AppCommentModel

@app.task
def CloseApplication():
    import logging
    logger = logging.getLogger(__name__)
    logger.info("=== TASK STARTED ===")
    try:
        status = StatusModel.objects.get(id=4)
        user = User.objects.get(id=1)

        # Дебаг: выводим текущее время
        now = django.utils.timezone.now()
        print(f"Current time: {now}")

        delta = now - timedelta(days=14)
        print(f"Delta time (14 days ago): {delta}")

        # 1. Находим ВСЕ заявки со статусом 3
        status3_apps = ApplicationModel.objects.filter(status_id=3)
        logger.info(f"Total apps with status 3: {status3_apps.count()}")

        # 2. Для каждой заявки получаем ПОСЛЕДНЮЮ запись в AppStatusModel
        apps_to_close = []
        for app in status3_apps:
            try:
                # Получаем последнюю запись статуса для этой заявки
                last_status = app.appstatuses.order_by('-pubdate').first()

                if not last_status:
                    logger.warning(f"App {app.id} has no status history!")
                    continue

                logger.info(f"App {app.id} last status: {last_status.status_id} at {last_status.pubdate}")

                # Проверяем условия:
                # 1. Последний статус = 3
                # 2. Дата последнего статуса 3 > 14 дней
                if last_status.status_id == 3 and last_status.pubdate < delta:
                    logger.info(f"Should close app {app.id} (last status 3 at {last_status.pubdate})")
                    apps_to_close.append(app)

            except Exception as e:
                logger.error(f"Error processing app {app.id}: {str(e)}")
                continue

        logger.info(f"Found {len(apps_to_close)} apps to close")

        for app in apps_to_close:
            app.status = status
            app.save()

            # Создаем запись в истории статусов
            AppStatusModel.objects.create(
                application=app,
                status=status,
            )

            # Запись в истории
            AppHistoryModel.objects.create(
                type=1,
                text=f'Статус заявки изменен на "{status}". Закрыто автоматически',
                application=app,
                author=user
            )

            # Отправка email (без request)
            email_url = f"{settings.BASE_URL}{app.get_absolute_url()}"
            try:
                text = render_to_string('applications/mail.html', {
                    'id': app.pk,
                    'url': email_url,
                    'status': status,
                    'type': 'edit'
                })
                mail = EmailMessage(
                    'Изменение статуса заявки',
                    text,
                    settings.EMAIL_HOST_USER,
                    [app.contact.email]
                )
                mail.content_subtype = "html"
                mail.send()
                AppHistoryModel.objects.create(
                    type=3,
                    text=f'Отправлено сообщение об изменении статуса на "{status}" на email {app.contact.email}',
                    application=app,
                    author=user
                )
            except Exception as e:
                AppHistoryModel.objects.create(
                    type=3,
                    text=f'Не удалось отправить сообщение об изменении статуса на "{status}" на email {app.contact.email}: {str(e)}',
                    application=app,
                    author=user
                )

            # Отправка в Telegram
            try:
                telegram_settings = settings.TELEGRAM
                bot = telegram.Bot(token=telegram_settings['bot_token'])
                tg_url = f"{settings.BASE_URL}{app.get_absolute_url()}"
                text = render_to_string('applications/telegram.html', {
                    'id': app.pk,
                    'url': tg_url,
                    'status': status,
                    'type': 'edit'
                })
                bot.send_message(
                    chat_id=telegram_settings['channel_id'],
                    text=text,
                    parse_mode=telegram.ParseMode.HTML
                )
                AppHistoryModel.objects.create(
                    type=4,
                    text=f'Отправлено сообщение об изменении статуса на "{status}" в Telegram',
                    application=app,
                    author=user
                )
            except Exception as e:
                AppHistoryModel.objects.create(
                    type=4,
                    text=f'Не удалось отправить сообщение в Telegram: {str(e)}',
                    application=app,
                    author=user
                )

        # Архивирование старых заявок (1 год)
        archive_delta = django.utils.timezone.now() - relativedelta(years=1)
        archives = ApplicationModel.objects.filter(status_id=4, pubdate__lt=archive_delta)

        for record in archives:
            try:
                main_engineer = record.engineers.first() if record.engineers.exists() else None
                ApplicationArchiveModel.objects.create(
                    old_id=record.id,
                    priority=record.priority,
                    equipment=record.equipment.equipment if record.equipment else None,
                    problem=record.problem,
                    contact=record.contact,
                    client=record.client,
                    engineer=main_engineer,
                    pubdate=record.pubdate,
                    status=record.status,
                    creator=record.creator
                )
                record.delete()
            except Exception as e:
                logger.error(f"Ошибка при архивировании заявки {record.id}: {str(e)}")

        return f"Успешно закрыто {len(apps_to_close)} заявок"

    except Exception as e:
        logger.error(f"Ошибка в задаче CloseApplication: {str(e)}")
        raise

def decode_subject(subject):
    """Корректно декодирует заголовок Subject."""
    if subject:
        decoded_parts = decode_header(subject)
        return "".join(
            part.decode(encoding or "utf-8") if isinstance(part, bytes) else part
            for part, encoding in decoded_parts
        )
    return ""

@app.task
def CommentsFromEmails():
    from datetime import date, timedelta
    import logging
    from django.utils import timezone
    from email.utils import parsedate_to_datetime
    logger = logging.getLogger(__name__)
    try:
        last_uid = EmailLastUID.objects.get(id=1)
    except EmailLastUID.DoesNotExist:
        last_uid = None

    since_date_str  = (date.today() - timedelta(days=1)).strftime("%d-%b-%Y")

    imap = imaplib.IMAP4_SSL(settings.EMAIL_HOST_IMAP)
    imap.login(settings.EMAIL_HOST_USER, settings.EMAIL_HOST_PASSWORD)

    imap.select("INBOX", readonly=True)

    # Если есть последний UID, ищем письма с UID больше него
    if last_uid:
        result, data = imap.uid(
                'search',
                None,
                f'UID {last_uid.uid + 1}:*'
            )
    else:
        result, data = imap.search(
            None,
            'SINCE', since_date_str
        )

    if result != 'OK':
        logger.error(f"IMAP SEARCH failed: {data}")
        return

    email_uids = data[0].split()
    if not email_uids:
        logger.info(f"email_uids отсутсвуют")
        return {'status': 'info', 'message': 'email_uids отсутсвуют'}
    latest_email_uid = int(email_uids[-1])
    if last_uid and latest_email_uid <= last_uid.uid:
        logger.info(f"нет подходящих писем для обработки")
        return {'status': 'info', 'message': 'нет подходящих писем для обработки'}

    messages = []
    messages_uids = []
    successful = True

    for message in email_uids:
        result, data = imap.uid("fetch", message, "(RFC822)")
        raw_email = data[0][1]
        email_message = email.message_from_bytes(raw_email)

        subject = decode_subject(email_message.get("Subject", ""))
        subject = decode_subject(email_message.get("Subject", ""))
        from_email = email.utils.parseaddr(email_message["From"])[1].lower().strip()

        # --- ФИЛЬТРЫ ---
        if from_email == "mailer-daemon@yandex.ru":
            logger.info(f"Пропущено служебное письмо от {from_email}")
            continue

        if "ticketid" in subject.lower():
            logger.info(f"Пропущено письмо с TicketID в теме: {subject}")
            continue
        # ----------------
        app_text = re.search(r"заявк. № (\d+)", subject, re.IGNORECASE)

        if app_text:
            app_number = app_text.group(1)
            from_email = email.utils.parseaddr(email_message["From"])[1]
            body = ""
            if email_message.is_multipart():
                for part in email_message.walk():
                    if part.get_content_type() == "text/plain" and not part.get_filename():
                        payload = part.get_payload(decode=True)
                        charset = part.get_content_charset() or "utf-8"
                        body = payload.decode(charset, errors="ignore")
                        break
            else:
                payload = email_message.get_payload(decode=True)
                charset = email_message.get_content_charset() or "utf-8"
                body = payload.decode(charset, errors="ignore")
            # Очищаем тело письма от истории переписки
            logger.info(f"=========================\n")
            logger.info(repr(body))
            logger.info(f"=========================\n")
            import markdown
            def clean_body(text):
                if is_markdown(text):
                    text = markdown.markdown(text, output_format='html5')
                # 1. Находим первый разделитель ----------------
                # Ищем <div> с разделителем
                # 2. Парсим HTML и ищем первый <blockquote>
                    soup = BeautifulSoup(text, 'html.parser')
                    blockquote = soup.find('blockquote')

                    if blockquote:
                        # Находим позицию первого <blockquote> в исходном HTML
                        blockquote_start = str(soup).find(str(blockquote))
                        # Берём текст ДО <blockquote>
                        main_content = text[:blockquote_start].strip()
                    else:
                        main_content = text.strip()

                    # 3. Очищаем оставшуюся часть от HTML-тегов и мусора
                    soup_clean = BeautifulSoup(main_content, 'html.parser')

                    # Удаляем пустые теги (<div></div>, <p></p> и т.п.)
                    for empty in soup_clean.find_all():
                        if not empty.get_text(strip=True) and not empty.name in ['br', 'hr']:
                            empty.decompose()

                    main_content = str(soup_clean)

                    # 4. Удаляем оставшиеся HTML-теги, сохраняя текст
                    soup_text = BeautifulSoup(main_content, 'html.parser')
                    main_content = soup_text.get_text(separator=' ', strip=True)

                    # 5. Нормализуем пробелы и переносы
                    main_content = re.sub(r'\s+', ' ', main_content).strip()

                    # Удаляем возможные остатки \n, \r
                    main_content = main_content.replace('\n', ' ').replace('\r', ' ').strip()

                    # 6. Удаляем подписи (если остались)
                    signature_patterns = [
                        r'С\s+уважением[,:]?\s*[^<]+(?:\s+[\w\.-]+@[\w\.-]+\.[a-z]{2,})?',
                        r'[\w\.-]+@[\w\.-]+\.[a-z]{2,}\s+С\s+уважением',
                        r'Отправлено из[^<]*',
                        r'Best regards[^<]*',
                        r'Kind regards[^<]*'
                    ]
                    for pattern in signature_patterns:
                        main_content = re.sub(pattern, '', main_content, flags=re.IGNORECASE)


                    # 7. Финальная очистка пробелов
                    main_content = re.sub(r'\s+', ' ', main_content).strip()

                else:
                    # Паттерн для поиска div с разделителем если html изначально
                    divider_pattern = r'<div[^>]*>\s*-{4,}\s*</div>'
                    match = re.search(divider_pattern, text)

                    if match:
                        # Берем текст до разделителя
                        main_content = text[:match.start()].rstrip()
                    else:
                        main_content = text.rstrip()

                    # 2. Удаляем лишние пустые теги в конце
                    # Список паттернов для удаления
                    patterns_to_remove = [
                        r'<div>\s*<br\s*/?>\s*</div>\s*<div>\s*<br\s*/?>\s*</div>\s*$',
                        r'<div>\s*<br\s*/?>\s*</div>\s*$',
                        r'<div>\s*</div>\s*$',
                        r'<br\s*/?>\s*$'
                    ]

                    for pattern in patterns_to_remove:
                        main_content = re.sub(pattern, '', main_content).rstrip()

                logger.info(repr(text))

                # 4. Добавляем новый форматированный разделитель
                result = main_content + '<div>----------------</div><div class="text-muted">Сообщение сформировано из электронной почты от <b>'+ from_email +'!</b></div>'
                return result

            def is_markdown(text):
                """
                Проверяет, содержит ли текст типичные элементы Markdown.
                Возвращает True, если похоже на Markdown.
                """
                # Паттерны Markdown
                patterns = [
                    r'^#{1,6}\s+.+',           # Заголовки #, ##, ###
                    r'^\*\s+.+',                 # Маркированный список (* item)
                    r'^-{3,}\s*$',             # Горизонтальная линия (---)
                    r'\*\*.+\*\*',              # Жирный текст (**bold**)
                    r'\*.+\*',                 # Курсив (*italic*)
                    r'\[.+\]\(.+\)',           # Ссылки [текст](url)
                    r'`{1,3}.+`{1,3}',       # Инлайн-код `code` или ```code```
                ]

                for pattern in patterns:
                    if re.search(pattern, text, re.MULTILINE):
                        return True
                return False
            body = clean_body(body)

            # Если после очистки тело пустое — берём хотя бы первую строку
            if not body:
                body = lines[0].strip() if lines else ""
            email_date = parsedate_to_datetime(email_message.get("Date"))
            if email_date and timezone.is_naive(email_date):
                email_date = timezone.make_aware(email_date)

            logger.info(repr(body))  # ← здесь вы увидите нормальную кириллицу
            uid_int = int(message.decode("utf-8"))
            messages.append({
                "text": body.strip(),
                "application_id": int(app_number),
                "author_id": from_email,
                "email_date": email_date
            })
            messages_uids.append({"message_uid": uid_int})

    if messages:
        #User = get_user_model()
        #users = {user["email"]: user["id"] for user in User.objects.values("id", "email")}

        for index, message in enumerate(messages):
            #message["author_id"] = users.get(message["author_id"])
            message["author_id"] = 104
            logger.error(f"failed2222: {message['author_id']}")
            if message["author_id"]:
                last_uid_new = int(messages_uids[index]["message_uid"])
                logger.error(f"failed2222: {last_uid_new}")
                try:
                    AppCommentModel.objects.create(**message)

                except Exception as e:
                    logger.error(f"failed: {e}")
                    break
    #logger.error(f"failed2222: {last_uid_new}")
    if last_uid:
        if 'last_uid_new' in locals() and last_uid_new > last_uid.uid:
            last_uid.success = True
            last_uid.uid = last_uid_new
            last_uid.pubdate = timezone.now()
            last_uid.save()
    elif 'last_uid_new' in locals():
        EmailLastUID.objects.create(success=True, uid=last_uid_new)
    # if comments:
    #     try:
    #         AppCommentModel.objects.bulk_create([AppCommentModel(**vals) for vals in comments])
    #         if last_uid:
    #             last_uid.success = True
    #             last_uid.uid = latest_email_uid
    #             last_uid.save()
    #         else:
    #             EmailLastUID.objects.create(success = True, uid = latest_email_uid)
    #         return HttpResponse('successful')
    #     except:
    #         return HttpResponse('failed')

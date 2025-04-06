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
User = get_user_model()

from applications.models import ApplicationModel, AppStatusModel, StatusModel, AppHistoryModel, ApplicationArchiveModel, EmailLastUID, AppCommentModel

@app.task
def CloseApplication():

    status = StatusModel.objects.get(id = 4)
    user = User.objects.get(id = 1)

    records = []
    old_apps = []
    delta = django.utils.timezone.now() - timedelta(days = 14)#3
    apps = ApplicationModel.objects.filter(status_id = 3).prefetch_related(Prefetch('appstatuses', queryset = AppStatusModel.objects.filter(status_id = 3)))

    for app in apps:
        for st in app.appstatuses.all():
            if(st.pubdate < delta):
                records.append({'application': app, 'status_id': 4})
                app.status = status
                app.save()

                AppHistoryModel.objects.create(type = 1, text = 'Статус заявки изменен на "' + str(status) + '". Закрыто автоматически', application = app, author = user)

    list = [AppStatusModel(**vals) for vals in records]

    AppStatusModel.objects.bulk_create(list)

    for app in apps:
        text = render_to_string('applications/mail.html', {'id': app.pk, 'url': request.build_absolute_uri(app.get_absolute_url()), 'status': status, 'type': 'edit'})
        mail = EmailMessage('Изменение статуса заявки', text, settings.EMAIL_HOST_USER, [app.contact.email])
        mail.content_subtype = "html"
        try:
            mail.send()
        except Exception:
            AppHistoryModel.objects.create(type = 3, text = 'Не удалось отправить сообщение об изменении статуса заявки на "' + str(status) + '" на адрес электронной почты ' + app.contact.email, application = app, author = user)
        else:
            AppHistoryModel.objects.create(type = 3, text = 'Отправлено сообщение об изменении статуса заявки на "' + str(status) + '" на адрес электронной почты ' + app.contact.email, application = app, author = user)

        telegram_settings = settings.TELEGRAM
        bot = telegram.Bot(token = telegram_settings['bot_token'])
        text = render_to_string('applications/telegram.html', {'id': app.pk, 'url': request.build_absolute_uri(app.get_absolute_url()), 'status': status, 'type': 'edit'})
        try:
            bot.send_message(chat_id = telegram_settings['channel_id'], text = text, parse_mode = telegram.ParseMode.HTML)
        except Exception:
            AppHistoryModel.objects.create(type = 4, text = 'Не удалось отправить сообщение об изменении статуса заявки на "' + str(status) + '" в телеграм-канал', application = app, author = user)
        else:
            AppHistoryModel.objects.create(type = 4, text = 'Отправлено сообщение об изменении статуса заявки на "' + str(status) + '" в телеграм-канал', application = app, author = user)

    # Архив заявок
    delta = django.utils.timezone.now() - relativedelta(years = 1)
    archives = ApplicationModel.objects.filter(status_id = 4, pubdate__lt = delta)
    for record in archives:
        try:
            ApplicationArchiveModel.objects.create(old_id = record.id, priority = record.priority, equipment = record.equipment, problem = record.problem,\
                contact = record.contact, client = record.client, engineer = record.engineer, pubdate = record.pubdate,\
                status = record.status, creator = record.creator)

            record.delete()
        except Exception:
            pass

    return HttpResponse(apps)

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
    try:
        last_uid = EmailLastUID.objects.get(id=1)
    except EmailLastUID.DoesNotExist:
        last_uid = None

    date = (datetime.date.today() - datetime.timedelta(1)).strftime("%d-%b-%Y")

    imap = imaplib.IMAP4_SSL(settings.EMAIL_HOST_IMAP)
    imap.login(settings.EMAIL_HOST_USER, settings.EMAIL_HOST_PASSWORD)

    imap.select("INBOX", readonly=True)

    search_criteria = ['SINCE', date, 'SUBJECT', u'заявк'.encode('utf-8')]
    if last_uid:
        search_criteria = ['UID', f"{last_uid.uid}:*", 'SUBJECT', u'заявк'.encode('utf-8')]

    result, data = imap.search(None, *search_criteria)

    email_uids = data[0].split()

    if not email_uids:
        return HttpResponse('successful')

    latest_email_uid = int(email_uids[-1])
    if last_uid and latest_email_uid < last_uid.uid:
        return HttpResponse('successful')

    messages = []
    successful = True

    for message in email_uids:
        result, data = imap.uid("fetch", message, "(RFC822)")
        raw_email = data[0][1].decode("utf-8")
        email_message = email.message_from_string(raw_email)

        subject = decode_subject(email_message.get("Subject", ""))
        app_text = re.search(r"заявк. № (\d+)", subject, re.IGNORECASE | re.UNICODE)

        if app_text:
            app_number = app_text.group(1)
            from_email = email.utils.parseaddr(email_message["From"])[1]

            body = ""
            if email_message.is_multipart():
                for part in email_message.walk():
                    content_type = part.get_content_type()
                    content_disposition = str(part.get("Content-Disposition"))

                    if "attachment" not in content_disposition and content_type == "text/plain":
                        body = part.get_payload(decode=True).decode("utf-8", errors="ignore")
                        break
            else:
                body = email_message.get_payload(decode=True).decode("utf-8", errors="ignore")

            messages.append({
                "text": body.strip(),
                "application_id": int(app_number),
                "author_id": from_email,
                "email_date": datetime.datetime.strptime(
                    email_message["Date"], "%a, %d %b %Y %H:%M:%S %z"
                ),
            })

    if messages:
        User = get_user_model()
        users = {user["email"]: user["id"] for user in User.objects.values("id", "email")}

        for message in messages:
            message["author_id"] = users.get(message["author_id"])
            if message["author_id"]:
                try:
                    AppCommentModel.objects.create(**message)
                except Exception as e:
                    successful = False

    if successful:
        if last_uid:
            last_uid.success = True
            last_uid.uid = latest_email_uid + 1
            last_uid.pubdate = datetime.datetime.now()
            last_uid.save()
        else:
            EmailLastUID.objects.create(success=True, uid=latest_email_uid)

    return HttpResponse(successful)
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

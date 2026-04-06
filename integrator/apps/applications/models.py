import os
from datetime import datetime

from django.db import models
from django.db.models import OuterRef, F, Subquery
from django.contrib.auth import get_user_model
from django.db.models.functions import Coalesce
from django.conf import settings
from django.urls import reverse

from io import BytesIO
from django.core.files import File
from ckeditor.fields import RichTextField
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.utils.functional import cached_property
from bs4 import BeautifulSoup

import barcode                      # additional imports
from barcode.writer import ImageWriter

from pytils import translit

from accounts.models import OrganizationContactModel
from contracts.models import ContractEquipmentModel
from equipments.models import EquipmentModel
from spares.models import SpareModel

from integrator.apps.functions import send_email, send_telegram

def file_name(instance, filename):
    path = 'applications/' + str(instance.application.pk) + '/'
    ext = filename.split('.')[-1]
    filename = datetime.now().strftime("%d%m%Y%H%M%S") + '.' + ext
    return os.path.join(path, filename)

def file_conf(instance, filename):
    path = 'equipments/' + str(instance.equipment.pk) + '/'
    ext = filename.split('.')[-1]

    filename =  translit.slugify(filename.replace('.' + ext, ''))
    if ext:
        filename = filename + '.' + ext

    return os.path.join(path, filename)

def file_contract(instance, filename):
    path = 'contracts/' + str(instance.contract.pk) + '/'
    ext = filename.split('.')[-1]
    if ext:
        filename = filename.replace('.' + ext, '')
    filename =  translit.slugify(filename)
    if ext:
        filename = filename + '.' + ext
    return os.path.join(path, filename)

class AppPriorityModel(models.Model):
    name = models.CharField('Наименование', max_length = 300)
    priority = models.IntegerField('Приоритет', default = 0)

    def __str__(self):
        return self.name

    class Meta:
        verbose_name = 'Приоритет заявки'
        verbose_name_plural = 'Приоритеты заявок'
        ordering = ['priority', 'name']

class EquipmentConfigModel(models.Model):
    from integrator.apps.validators import validate_format, validate_size_10

    document = models.FileField('Файл', upload_to = file_conf, validators = [validate_format, validate_size_10])
    equipment = models.ForeignKey(EquipmentModel, verbose_name = 'Оборудование', on_delete = models.CASCADE, related_name = "equipconf")

    def __str__(self):
        return str(self.equipment)

    class Meta:
        verbose_name = 'Файл конфигурации'
        verbose_name_plural = 'Файлы конфигурации оборудования'


class StatusModel(models.Model):
    name = models.CharField('Наименование', max_length = 300)
    priority = models.IntegerField('Приоритет', default = 0)

    def __str__(self):
        return self.name

    class Meta:
        verbose_name = 'Статус заявки'
        verbose_name_plural = 'Статусы заявок'
        ordering = ['priority', 'name']

class ApplicationModel(models.Model):
    priority = models.ForeignKey(AppPriorityModel, verbose_name = 'Приоритет заявки', on_delete = models.PROTECT, related_name = "priorities", null = True)
    equipment = models.ForeignKey(ContractEquipmentModel, verbose_name = 'Оборудование', on_delete = models.PROTECT, related_name = "equipments", null = True)
    problem = models.TextField('Описание проблемы')
    contact = models.ForeignKey(OrganizationContactModel, verbose_name = 'Контактное лицо', on_delete = models.SET_NULL, related_name = "appcontact", null = True)
    client = models.ForeignKey(settings.AUTH_USER_MODEL, verbose_name = 'Заказчик', on_delete = models.PROTECT, related_name = "appclients", null = True)
    engineers = models.ManyToManyField(
        settings.AUTH_USER_MODEL,
        verbose_name='Инженеры',
        related_name='assigned_applications',
        blank=True
    )
    pubdate = models.DateTimeField('Дата создания', auto_now_add = True)
    status = models.ForeignKey(StatusModel, verbose_name = 'Статус заявки', on_delete = models.PROTECT, null = True)
    creator = models.ForeignKey(settings.AUTH_USER_MODEL, verbose_name = 'Создано', on_delete = models.PROTECT, related_name = "creators", null = True)
    changed = models.BooleanField('Оборудование изменено', default = False)
    # Новое поле для связи с контрактом
    contract = models.ForeignKey(
        'contracts.ContractModel', # Ссылка на модель (приложение.Модель)
        verbose_name='Контракт',
        on_delete=models.SET_NULL,
        related_name='applications',
        null=True,
        blank=True
    )

    # Новое поле для связи с пользователем-контактом
    contact_user = models.ForeignKey(
        settings.AUTH_USER_MODEL, # Ссылка на системную модель пользователя
        verbose_name='Связанный пользователь',
        on_delete=models.SET_NULL,
        related_name='contact_applications',
        null=True,
        blank=True
    )
    def __str__(self):
        return str(self.id)

    def get_absolute_url(self):
        return reverse('edit-application', kwargs = {'application_id': int(self.pk)})

    class Meta:
        verbose_name = 'Заявка'
        verbose_name_plural = 'Заявки'
        ordering = ['status__priority', '-id',]

class AppDocumentsModel(models.Model):
    from integrator.apps.validators import validate_format, validate_size

    name = models.CharField('Наименование файла', max_length = 300, blank = True)
    document = models.FileField('Файл', upload_to = file_name, validators = [validate_format, validate_size])
    application = models.ForeignKey(ApplicationModel, verbose_name = 'Заявка', on_delete = models.CASCADE, related_name = "documents", null = True)

    def __str__(self):
        return self.name
    import os
    def save(self, *args, **kwargs):
        if not self.name:
            self.name = os.path.basename(self.document.name)
        super().save(*args, **kwargs)

    @cached_property
    def filesize(self):
        """Возвращает размер файла в удобочитаемом формате"""
        if self.document:
            try:
                size_bytes = self.document.size
                return self.human_readable_size(size_bytes)
            except (ValueError, OSError):
                return "0 B"
        return "0 B"

    @staticmethod
    def human_readable_size(size_bytes):
        """Конвертирует размер в байтах в удобочитаемый формат"""
        for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
            if size_bytes < 1024.0:
                return f"{size_bytes:.1f} {unit}"
            size_bytes /= 1024.0
        return f"{size_bytes:.1f} PB"

class AppStatusModel(models.Model):
    status = models.ForeignKey(StatusModel, verbose_name = 'Статус заявки', on_delete = models.SET_NULL, related_name = "statuses", null = True)
    application = models.ForeignKey(ApplicationModel, on_delete = models.CASCADE, related_name = "appstatuses", null = True)
    pubdate = models.DateTimeField('Дата создания', auto_now_add = True)

    def __str__(self):
        return str(self.application)

    class Meta:
        ordering = ['-pubdate']

class AppCommentModel(models.Model):
    text = RichTextField('Комментарий', config_name = 'small')
    hide = models.BooleanField('Скрыть комментарий от клиента', default = False)
    pubdate = models.DateTimeField('Дата создания', auto_now_add = True)
    email_date = models.DateTimeField('Дата создания', null = True, blank = True)
    edited = models.BooleanField('Комментарий был отредактирован', default = False)
    application = models.ForeignKey(ApplicationModel, verbose_name = 'Заявка', on_delete = models.CASCADE, related_name = "comments")
    author = models.ForeignKey(settings.AUTH_USER_MODEL, verbose_name = 'Автор', on_delete = models.SET_NULL, null = True, related_name = "authors")

    def __str__(self):
        return self.text

    def save(self, *args, **kwargs):
        method_type = 'created' if not self.pk else 'updated'
        super(AppCommentModel, self).save(*args, **kwargs)

        comments_send_messages(self, method_type)

    def delete(self, *args, **kwargs):
        super(AppCommentModel, self).delete(*args, **kwargs)

        comments_send_messages(self, 'deleted')

    class Meta:
        ordering = ['-pubdate']

def comments_send_messages(comment, method_type):
    # Аннотируем заявку инженерами
    User = get_user_model()
    application = ApplicationModel.objects.annotate(
        email=Subquery(OrganizationContactModel.objects.filter(id=OuterRef('contact_id')).values('email')[:1])
    ).get(id=comment.application_id)

    # Преобразуем emails инженеров в список
    engineer_emails = list(
        User.objects.filter(
            id__in=application.engineers.all().values_list('id', flat=True)
        ).values_list('email', flat=True)
    )

    to_emails = []
    history = []
    host = settings.ALLOWED_HOSTS[1]
    params = {
        'id': application.id,
        'url': 'https://' + host + application.get_absolute_url(),
        'status': comment.text.strip(),
        'type': 'comment'
    }
    text = ''

    if not comment.email_date:
        to_emails.append(application.email)
    if engineer_emails:
        to_emails.extend(engineer_emails)

    title = ' комментарий к заявке № ' + str(application.id)

    if method_type == 'created':
        title = 'Добавлен' + title
        text_part = 'о добавлении'
    elif method_type == 'updated':
        title = 'Изменен' + title
        text_part = 'об изменении'
        params['type'] = 'comment_edit'
    else:
        title = 'Удален' + title
        text_part = 'об удалении'
        params['type'] = 'comment_delete'

    if to_emails:
        if send_email(params = params, title = title, send_to = to_emails):
            text = 'Отправлено сообщение ' + text_part + ' комментария "' + comment.text + '" на электронную почту'
        else:
            text = 'Не удалось отправить сообщение ' + text_part + ' комментария "' + comment.text + '" на электронную почту'
        history.append({'type': 4, 'text': text, 'application': application, 'author': comment.author})

    # Очищаем HTML перед парсингом (уменьшаем нагрузку на BS4)
    telegram_text = comment.text.replace('&nbsp;', ' ')
    # Удаляем списки до парсинга — безопаснее
    for tag in ['<ul>', '</ul>', '<ol>', '</ol>']:
        telegram_text = telegram_text.replace(tag, '')

    try:
        Parse = BeautifulSoup(telegram_text, 'html.parser')
        tags_to_unwrap = ['p', 'span', 'blockquote', 'sup', 'sub', 'li', 'a', 'div']

        # Собираем все теги заранее (чтобы избежать проблем с изменением DOM)
        all_tags = Parse.find_all()

        for tag in all_tags:
            # Удаляем style, если есть
            if tag.has_attr('style'):
                del tag.attrs['style']

            # Обрабатываем <br>
            if tag.name == "br":
                tag.replace_with("\n")
                continue  # Пропускаем дальнейшие операции для <br>

            # Для нужных тегов — добавляем перенос строки и разворачиваем
            if tag.name in tags_to_unwrap:
                if tag.string and (tag.name == 'p' or tag.name == 'li'):
                    tag.string = tag.string + "\n"
                # Безопасный unwrap с проверкой
                if tag.parent:
                    tag.unwrap()
                else:
                    # Если тег уже не в дереве — просто удаляем его
                    tag.extract()

        telegram_text = str(Parse).strip()

    except Exception as e:
        # В случае ошибки используем исходный текст (без форматирования)
        logger.error(f"BS4 parsing error: {e}")
        telegram_text = comment.text.replace('&nbsp;', ' ')

    params['status'] = telegram_text
    params['author'] = comment.author.get_full_name() or comment.author.email

    if send_telegram(params=params):
        text = 'Отправлено сообщение ' + text_part + ' комментария в телеграм-канал'
    else:
        text = 'Не удалось отправить сообщение ' + text_part + ' комментария в телеграм-канал'
    history.append({'type': 4, 'text': text, 'application': application, 'author': comment.author})

    history_instance = [AppHistoryModel(**row) for row in history]
    AppHistoryModel.objects.bulk_create(history_instance)

class AppSpareModel(models.Model):
    spare = models.ForeignKey(SpareModel, verbose_name = 'Запчасть', on_delete = models.CASCADE, related_name = "appspare")
    application = models.ForeignKey(ApplicationModel, verbose_name = 'Заявка', on_delete = models.CASCADE, related_name = "appeqspare")
    pubdate = models.DateTimeField('Дата записи', auto_now_add = True)
    author = models.ForeignKey(settings.AUTH_USER_MODEL, verbose_name = 'Пользователь', on_delete = models.SET_NULL, null = True, related_name = "appspauthors")

    def __str__(self):
        return str(self.spare)

    def save(self, *args, **kwargs):
        super(AppSpareModel, self).save(*args, **kwargs)
        spares_send_messages(self, 'created')

    def delete(self, *args, **kwargs):
        spares_send_messages(self, 'deleted')
        super(AppSpareModel, self).delete(*args, **kwargs)

    class Meta:
        verbose_name = 'История ЗИП'
        verbose_name_plural = 'История ЗИП'
        ordering = ['-pubdate']

def spares_send_messages(spare, method_type):
    application = ApplicationModel.objects.prefetch_related('engineers').get(id=spare.application_id)

    # Получаем email всех инженеров
    engineer_emails = application.engineers.all().values_list('email', flat=True)

    spare_label = spare.spare.name + ' (S/n: ' + spare.spare.sn + ')'
    to_emails = []
    history = []
    host = settings.ALLOWED_HOSTS[1]
    params = {
        'id': application.id,
        'url': 'https://' + host + application.get_absolute_url(),
        'status': spare_label,
        'type': 'spare'
    }
    text = ''

    if method_type == 'created':
        title = 'Списание запчасти'
        text = 'Списание запчасти "' + spare_label + '"'
        text_part = 'списании'
        history.append({'type': 5, 'text': text, 'application': application, 'author': spare.author})
    else:
        params['type'] = 'return'
        title = 'Возврат запчасти'
        text = 'Возврат запчасти "' + spare_label + '"'
        text_part = 'возврате'
        history.append({'type': 6, 'text': text, 'application': application, 'author': spare.author})

     # Отправка всем инженерам
    if engineer_emails:
        if send_email(params=params, title=title, send_to=list(engineer_emails)):
            text = f'Отправлено сообщение о {text_part} запчасти "{spare_label}" на адреса электронной почты: {", ".join(engineer_emails)}'
        else:
            text = f'Не удалось отправить сообщение о {text_part} запчасти "{spare_label}" на адреса электронной почты: {", ".join(engineer_emails)}'
        history.append({'type': 4, 'text': text, 'application': application, 'author': spare.author})

    if send_telegram(params = params):
        text = 'Отправлено сообщение о ' + text_part + ' запчасти "' + spare_label + '" в телеграм-канал'
    else:
        text = 'Не удалось отправить сообщение о ' + text_part + ' запчасти "' + spare_label + '" в телеграм-канал'
    history.append({'type': 4, 'text': text, 'application': application, 'author': spare.author})

    history_instance = [AppHistoryModel(**row) for row in history]
    AppHistoryModel.objects.bulk_create(history_instance)


class AppHistoryModel(models.Model):
    types = (
        (1, 'Изменение статуса'),
        (2, 'Изменение значения поля'),
        (3, 'Отправка сообщения на адрес электронной почты'),
        (4, 'Отправка сообщения в телеграм-канал'),
        (5, 'Списание запчасти'),
        (6, 'Возврат запчасти'),
        (7, 'Добавление файлов'),
    )

    type = models.IntegerField('Тип события', choices = types)
    text = models.TextField('Текст')
    pubdate = models.DateTimeField('Дата записи', auto_now_add = True)
    number = models.IntegerField('Номер заявки', null = True, blank = True)
    application = models.ForeignKey(ApplicationModel, verbose_name = 'Заявка', on_delete = models.SET_NULL, null = True)
    author = models.ForeignKey(settings.AUTH_USER_MODEL, verbose_name = 'Пользователь', on_delete = models.DO_NOTHING)

    def __str__(self):
        return self.text

    class Meta:
        ordering = ['-pubdate']

class AppHistoryViewedModel(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, verbose_name = 'Пользователь', on_delete = models.CASCADE)
    history = models.ForeignKey(AppHistoryModel, verbose_name = 'Событие', on_delete = models.CASCADE, related_name = "viewed")

    class Meta:
        unique_together = ('user', 'history',)

class ApplicationArchiveModel(models.Model):
    from django.db.models import Q

    priority = models.ForeignKey(AppPriorityModel, verbose_name = 'Приоритет заявки', on_delete = models.SET_NULL, related_name = "archpriorities", null = True)
    equipment = models.ForeignKey(EquipmentModel, verbose_name = 'Оборудование', on_delete = models.SET_NULL, related_name = "archequipments", null = True)
    problem = models.TextField('Описание проблемы')
    contact = models.ForeignKey(OrganizationContactModel, verbose_name = 'Контактное лицо', on_delete = models.SET_NULL, related_name = "archcontact", null = True)
    client = models.ForeignKey(settings.AUTH_USER_MODEL, verbose_name = 'Заказчик', on_delete = models.SET_NULL, related_name = "archclients", null = True)
    engineer = models.ForeignKey(settings.AUTH_USER_MODEL, verbose_name = 'Инженер', on_delete = models.SET_NULL, related_name = "archengineers", null = True, blank = True)
    pubdate = models.DateTimeField('Дата создания')
    status = models.ForeignKey(StatusModel, verbose_name = 'Статус заявки', on_delete = models.SET_NULL, null = True)
    creator = models.ForeignKey(settings.AUTH_USER_MODEL, verbose_name = 'Создано', on_delete = models.SET_NULL, related_name = "archcreators", null = True)
    old_id = models.IntegerField('Номер заявки')

    def __str__(self):
        return str(self.old_id)

    def get_absolute_url(self):
        return reverse('edit-application', kwargs = {'application_id': int(self.pk)})

    class Meta:
        verbose_name = 'Заявка'
        verbose_name_plural = 'Архив заявок'
        ordering = ['-pubdate']

class EmailLastUID(models.Model):
    uid = models.PositiveIntegerField('UID последнего прочитанного сообщения')
    success = models.BooleanField('Попытка удачная', default = False)
    pubdate = models.DateTimeField('Дата создания записи', auto_now_add = True)

    def has_add_permission(self, request):
        base_add_permission = super(EmailLastUID, self).has_add_permission(request)
        if base_add_permission:
            # if there's already an entry, do not allow adding
            count = EmailLastUID.objects.all().count()
            if count == 0:
                return True
        return False

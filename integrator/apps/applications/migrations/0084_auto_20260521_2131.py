from django.db import migrations
from django.utils import timezone

def create_email_uid_for_apps(apps, schema_editor):
    # Получаем модель динамически через историческое состояние миграций
    EmailLastUID = apps.get_model('applications', 'EmailLastUID')

    # Создаем запись с id=2 для таска автосоздания заявок, если её ещё нет
    EmailLastUID.objects.get_or_create(
        id=2,
        defaults={
            'uid': 0,
            'success': True,
            'pubdate': timezone.now()
        }
    )

def remove_email_uid_for_apps(apps, schema_editor):
    EmailLastUID = apps.get_model('applications', 'EmailLastUID')
    EmailLastUID.objects.filter(id=2).delete()

class Migration(migrations.Migration):

    dependencies = [
        # Убедись, что здесь указана последняя реальная миграция твоего приложения applications
        ('applications', '0001_initial'),
    ]

    operations = [
        migrations.RunPython(create_email_uid_for_apps, reverse_code=remove_email_uid_for_apps),
    ]

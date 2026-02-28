import os
from celery import Celery
from celery.schedules import crontab

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'integrator.settings')

app = Celery('integrator')
app.conf.update(
    broker_url='redis://redis:6379/0',
    result_backend='redis://redis:6379/1',
    task_serializer='json',
    accept_content=['json'],
    result_serializer='json',
    timezone='UTC',
    enable_utc=True,
)
app.config_from_object('django.conf:settings')

# Load task modules from all registered Django app configs.
app.autodiscover_tasks()

app.conf.beat_schedule = {
    'close-aplication': {
        'task': 'applications.tasks.CloseApplication',
        'schedule': crontab(minute='*/60'), #Каждый час
    },
    'comments-from-emails': {
        'task': 'applications.tasks.CommentsFromEmails',
        'schedule': crontab(minute='*/1'), #Каждые 5 минут
    }
}

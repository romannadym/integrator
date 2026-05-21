from django.conf import settings

def global_alert_processor(request):
    return {
        'SHOW_GLOBAL_ALERT': getattr(settings, 'SHOW_GLOBAL_ALERT', False),
        'GLOBAL_ALERT_TEXT': getattr(settings, 'GLOBAL_ALERT_TEXT', ''),
    }

from django.shortcuts import render, redirect
from django.urls import reverse
from django.contrib.auth.decorators import login_required
@login_required(login_url='/user_login/')  # Замените на правильный URL для вашей страницы входа
def IndexView(request): #Главная страница
    if request.user.is_authenticated:
        return redirect(reverse('app-list'))  # Если пользователь уже авторизован, редиректим на app-list
    from partners.models import PartnerModel

    partners = PartnerModel.objects.all()
    context = {'partners': partners}

    return render(request, 'main/index.html', context)

def ServicesView(request): #Услуги
    from services.models import ServiceModel

    services = ServiceModel.objects.all()
    context = {'services': services, 'show': request.user.groups.filter(name = 'Администратор').exists() or request.user.groups.filter(name = 'Инженер').exists(), 'admin': request.user.groups.filter(name = 'Администратор').exists()}

    return render(request, 'main/services.html', context)

def GetInTouchView(request): #Контакты
    from contacts.models import ContactModel
    from contacts.forms import GetInTouchForm
    from socials.models import SocialModel

    contacts = ContactModel.objects.first()
    socials = SocialModel.objects.all()
    form = GetInTouchForm()


    if request.method == "POST":
        from django.template.loader import render_to_string
        from django.core.mail import EmailMessage
        from django.conf import settings
        from django.http import JsonResponse
        import requests
        import json

        form = GetInTouchForm(request.POST)
        if form.is_valid():
            #dsfsdf
            key = ''
            token = request.POST.get('smart-token')
            # return HttpResponse(token)
            user_ip = request.META.get('HTTP_X_FORWARDED_FOR')
            if user_ip:
                ip = user_ip.split(',')[0]
            else:
                ip = request.META.get('REMOTE_ADDR')

            resp = requests.get('https://smartcaptcha.yandexcloud.net/validate', {'secret': key, 'token': token, 'ip': ip}, timeout = 1)
            data = resp.json()
            if data['status'] == 'ok':
                text = render_to_string('contacts/mail.html', {'data': request.POST})
                mail = EmailMessage('Обратная связь', text, settings.EMAIL_HOST_USER, ['support@myxcloud.ru'])#support@myxcloud.ru
                mail.content_subtype = "html"
                mail.send()
                return JsonResponse({'message': 'Обращение отправлено'})
            else:
                return JsonResponse({'error': 'Ошибка Yandex SmartCaptcha'})
        else:
            return JsonResponse(form.errors.as_json(), safe = False)

    context = {'contacts': contacts, 'socials': socials, 'form': form, 'show': request.user.groups.filter(name = 'Администратор').exists() or request.user.groups.filter(name = 'Инженер').exists(), 'admin': request.user.groups.filter(name = 'Администратор').exists()}

    return render(request, 'main/contacts.html', context)



def NotificationsView(request): #Просмотр уведомлений
    if request.method == "POST":
        from django.http import JsonResponse
        from applications.models import AppHistoryViewedModel

        history = []

        for key in request.POST:
            if key != 'csrfmiddlewaretoken':
                history.append({'history_id': request.POST.get(key), 'user_id': request.user.id})

        list = [AppHistoryViewedModel(**vals) for vals in history]

        AppHistoryViewedModel.objects.bulk_create(list, ignore_conflicts = True)

        return JsonResponse({'message': '1'})

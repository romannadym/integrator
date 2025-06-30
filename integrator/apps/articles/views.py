from django.shortcuts import render, redirect
from articles.models import ArticleModel
from integrator.apps.functions import is_admin_or_engineer

def ArticleListView(request):
    # Проверка прав доступа
    if not request.user.has_perm('articles.view_articlemodel') or request.user.groups.filter(name='Без БЗ').exists():
        return redirect('login')

    # Обработка AJAX-запросов DataTables
    if request.headers.get('x-requested-with') == 'XMLHttpRequest':
        from django.http import JsonResponse
        import sphinxapi
        import math

        try:
            # Параметры от DataTables
            draw = int(request.GET.get('draw', 1))
            start = int(request.GET.get('start', 0))
            length = int(request.GET.get('length', 50))  # items = 50 из старого кода
            search_value = request.GET.get('search[value]', '').strip()

            # Инициализация клиента Sphinx (как в рабочем коде)
            client = sphinxapi.SphinxClient()
            client.SetServer('sphinx', 9312)  # Как в рабочем коде
            client.SetRetries(1)
            client.SetMatchMode(sphinxapi.SPH_MATCH_PHRASE)  # Как в рабочем коде

            # Настройка лимитов (адаптировано под DataTables)
            client.SetLimits(start, length, max(1000, start + length + 100))

            if search_value:
                search = search_value.replace('$', '').replace('/', '')
                client.SetMatchMode(sphinxapi.SPH_MATCH_PHRASE)
                rows = client.Query(search)
            else:
                # Для пустого поиска получаем все записи
                rows = {'total_found': ArticleModel.objects.count(), 'matches': [{'id': a.id} for a in ArticleModel.objects.all()[start:start+length]]}
            # Формирование ответа в формате DataTables
            response = {
                'draw': draw,
                'recordsTotal': ArticleModel.objects.count(),  # Общее количество записей
                'recordsFiltered': rows['total_found'] if rows else 0,  # Количество найденных
                'data': []
            }

            if rows and 'matches' in rows:
                indexes = [item['id'] for item in rows['matches']]
                articles = ArticleModel.objects.filter(id__in=indexes)

                # Формируем данные как в рабочем коде
                response['data'] = [{
                    'id': item.id,
                    'title': item.title,
                    'number': item.number,
                    'header': item.header,
                    'summary': item.summary,
                    'text': item.text,
                    'products': item.products
                    # Добавьте другие поля по необходимости
                } for item in articles]

            return JsonResponse(response)

        except Exception as e:
            import traceback
            traceback.print_exc()
            return JsonResponse({
                'draw': draw,
                'recordsTotal': 0,
                'recordsFiltered': 0,
                'data': [],
                'error': str(e)
            }, status=500)

    # Обычный GET-запрос (первая загрузка страницы)
    permissions = {
        'is_admin': request.user.groups.filter(name='Администратор').exists(),
        'is_engineer': request.user.groups.filter(name='Инженер').exists(),
        'is_staff': is_admin_or_engineer(request.user)
    }

    return render(request, 'articles/list.html', {'permissions': permissions})



def ArticleDetailView(request, pk):
    permissions = {
        'is_admin': request.user.groups.filter(name='Администратор').exists(),
        'is_engineer': request.user.groups.filter(name='Инженер').exists(),
        'is_staff': is_admin_or_engineer(request.user)
    }
    if not request.user.has_perm('articles.view_articlemodel') or request.user.groups.filter(name = 'Без БЗ').exists():
        return redirect('login')

    article = ArticleModel.objects.get(pk = pk)
    context = {'article': article, 'permissions': permissions}
    return render(request, 'articles/detail.html', context)

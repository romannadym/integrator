from django.db.models import Q, F, Value, Case, When

from rest_framework import generics, status
from rest_framework.permissions import IsAuthenticated, IsAdminUser
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import JSONParser
from rest_framework.exceptions import APIException

from drf_spectacular.utils import extend_schema, OpenApiParameter, OpenApiResponse, OpenApiExample, OpenApiTypes

from accounts.models import User, OrganizationModel, OrganizationContactModel

from integrator.apps.parsers import NestedMultipartParser

from accounts.api.serializers import *

from integrator.apps.functions import is_admin_or_engineer, is_engineer, is_admin

@extend_schema(tags = ['Контакты организации (Done)'])
class ContactsListAPIView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(
        summary='Список контактов организации (для DataTables)',
        description='''
        <ol>
            <li>"id" - Идентификатор контакта</li>
            <li>"fio" - ФИО контакта</li>
        </ol>
        ''',
        parameters=[
            OpenApiParameter(name='organization_id', description='Идентификатор организации', type=int, required=True, location=OpenApiParameter.PATH),
            OpenApiParameter(name='draw', description='DataTables draw counter', type=int, required=False),
            OpenApiParameter(name='start', description='Pagination start index', type=int, required=False),
            OpenApiParameter(name='length', description='Number of records per page', type=int, required=False),
            OpenApiParameter(name='search[value]', description='Global search value', type=str, required=False),
            OpenApiParameter(name='order[0][column]', description='Column to order by', type=int, required=False),
            OpenApiParameter(name='order[0][dir]', description='Order direction (asc/desc)', type=str, required=False),
        ],
        responses={
            200: OpenApiResponse(
                response=OpenApiTypes.OBJECT,
                description='Response format for DataTables',
                examples=[
                    OpenApiExample(
                        name="DataTables example",
                        value={
                            "draw": 1,
                            "recordsTotal": 100,
                            "recordsFiltered": 50,
                            "data": [
                                {"id": 1, "fio": "Иванов Иван Иванович", "email": "ivanov@ivan.ru", "phone": "1111111"},
                                {"id": 2, "fio": "Петров Петр Петрович", "email": "petrov@petr.ru", "phone": "2222222"}
                            ]
                        }
                    )
                ]
            )
        }
    )
    def get(self, request, organization_id, *args, **kwargs):
        # Получаем параметры DataTables
        draw = int(request.GET.get('draw', 1))
        start = int(request.GET.get('start', 0))
        length = int(request.GET.get('length', 10))
        search_value = request.GET.get('search[value]', '')
        order_column = request.GET.get('order[0][column]', 0)
        order_dir = request.GET.get('order[0][dir]', 'asc')

        # Базовый запрос
        queryset = OrganizationContactModel.objects.filter(
            Q(organization_id=organization_id) &
            ~Q(email='serindework@mail.ru')
        )

        # Полное количество записей (до фильтрации)
        records_total = queryset.count()

        # Применяем поиск (если есть)
        if search_value:
            queryset = queryset.filter(
                Q(fio__icontains=search_value) |
                Q(email__icontains=search_value) |
                Q(phone__icontains=search_value)
            )
        # Количество записей после фильтрации
        records_filtered = queryset.count()

        # Определение сортировки
        order_fields = ['fio', 'email', 'phone']  # Замените на ваши поля
        try:
            order_field = order_fields[int(order_column)]
        except (IndexError, ValueError):
            order_field = 'fio'  # Значение по умолчанию

        if order_dir == 'desc':
            order_field = f'-{order_field}'

        # Применяем сортировку
        queryset = queryset.order_by(order_field)

        # Пагинация
        queryset = queryset[start:start + length]

        # Сериализация
        serializer = ContactsListSerializer(queryset, many=True)

        # Формируем ответ в формате DataTables
        response_data = {
            "draw": draw,
            "recordsTotal": records_total,
            "recordsFiltered": records_filtered,
            "data": serializer.data
        }

        return Response(response_data, status=status.HTTP_200_OK)

    @extend_schema(
        summary = 'Добавление контакта',
        description = '<ol><li>"fio" - ФИО</li><li>"email" - Адрес электронной почты</li><li>"phone" - Телефон</li></ol>',
        request = ContactSerializer(),
        parameters = [
            OpenApiParameter(name = 'organization_id', description = 'Идентификатор организации', type = int, required = True, location = OpenApiParameter.PATH),
        ],
        responses = {(201, 'application/json'): OpenApiResponse(response = ContactSerializer())}
    )
    def post(self, request, organization_id, *args, **kwargs):
        if is_engineer(request.user):
            return Response({'error': 'Функционал доступен только для клиентов и администраторов'}, status = status.HTTP_403_FORBIDDEN)

        serializer = ContactSerializer(data = request.data)
        if serializer.is_valid():
            serializer.save(organization_id = organization_id)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@extend_schema(tags = ['Контакты организации (Done)'])
class ContactAPIView(APIView):
    permission_classes = [IsAuthenticated,]

    @extend_schema(
        summary = 'Изменение контакта',
        description = '<ol><li>"fio" - ФИО</li><li>"email" - Адрес электронной почты</li><li>"phone" - Телефон</li></ol>',
        request = ContactSerializer(),
        parameters = [
            OpenApiParameter(name = 'contact_id', description = 'Идентификатор контакта', type = int, required = True, location = OpenApiParameter.PATH),
        ],
        responses = {(200, 'application/json'): OpenApiResponse(response = ContactSerializer())}
    )
    def put(self, request, contact_id, *args, **kwargs):
        contact = GetContact(contact_id)
        if not request.user.organization_id == contact.organization_id:
            return Response({'error': 'Доступ запрещен'}, status = status.HTTP_403_FORBIDDEN)

        serializer = ContactSerializer(contact, data = request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status = status.HTTP_200_OK)
        return Response(serializer.errors, status = status.HTTP_400_BAD_REQUEST)

    @extend_schema(
        summary = 'Удаление контакта',
        parameters = [
            OpenApiParameter(name = 'contact_id', description = 'Идентификатор контакта', type = int, required = True, location = OpenApiParameter.PATH),
        ],
        responses = {(200, 'application/json'): OpenApiResponse(response = {'message': 'Объект удален'}, examples = [OpenApiExample('Пример', value = {'message': 'Объект удален'})])}
    )
    def delete(self, request, contact_id, *args, **kwargs):
        contact = GetContact(contact_id)
        if not is_admin(request.user):
            if not request.user.organization_id == contact.organization_id:
                return Response({'error': 'Доступ запрещен'}, status = status.HTTP_403_FORBIDDEN)

        contact.delete()
        return Response({'message': 'Объект удален'}, status = status.HTTP_200_OK)

def GetContact(contact_id):
    try:
        return OrganizationContactModel.objects.get(id = contact_id)
    except:
        raise APIException('Контакт с id = ' + str(contact_id) + ' не найден')

#Список организаций
@extend_schema(
    tags = ['Организации (Done)'],
)
class OrganizationsListAPIView(APIView):
    permission_classes = [IsAdminUser,]
    parser_classes = [JSONParser, NestedMultipartParser]

    @extend_schema(
        summary = 'Список организаций',
        description = '<ol><li>"id" - Идентификатор организации</li><li>"name" - Наименование организации</li></ol>',
        responses = {(200, 'application/json'): OpenApiResponse(response = OrganizationsSerializer(many = True))}
    )
    def get(self, request, *args, **kwargs):
        search_term = request.GET.get('term', '').strip()
        queryset = OrganizationModel.objects.all()

        if search_term:
            queryset = queryset.filter(name__icontains=search_term)

        # Формат данных для Select2
        data = [{
            'id': org.id,
            'text': org.name
        } for org in queryset]

        return Response({'results': data}, status=status.HTTP_200_OK)

    @extend_schema(
        request = EditOrganizationSerializer(),
        summary = 'Добавление организации',
        description = '<ol><li>"name" - Наименование организации</li><li>"contacts" - список контактов, где\
        <ul><li>"fio" - ФИО контакта</li><li>"email" - Адрес электронной почты контакта</li><li>"phone" - Телефон контакта.</li></ul>\
        </li></ol><b>"id", "DELETE" используются в методе PUT, в этом указывать их ненужно</b>',
        responses = {(201, 'application/json'): OpenApiResponse(response = EditOrganizationSerializer())}
    )
    def post(self, request, *args, **kwargs):
        serializer = EditOrganizationSerializer(data = request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({'message': 'Элемент создан'}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@extend_schema(
    tags = ['Организации (Done)'],
)
class EditOrganizationAPIView(APIView):
    permission_classes = [IsAdminUser,]
    parser_classes = [JSONParser, NestedMultipartParser]

    @extend_schema(
        request = EditOrganizationSerializer(),
        summary = 'Изменение организации',
        description = '<ol><li>"name" - Наименование организации</li><li>"contacts" - список контактов, где\
        <ul><li>"id" - Идентификатор контакта</li><li>"fio" - ФИО контакта</li><li>"email" - Адрес электронной почты контакта</li><li>"phone" - Телефон контакта.</li><li>"DELETE" - Отметка об удалении ("True" - контакт будет удален)</li></ul>\
        </li></ol>',
        parameters = [
            OpenApiParameter(name = 'organization_id', description = 'Идентификатор организации', type = int, required = True, location = OpenApiParameter.PATH),
        ],
        responses = {(200, 'application/json'): OpenApiResponse(response = EditOrganizationSerializer())}
    )
    def put(self, request, organization_id, *args, **kwargs):
        organization = GetOrganization(organization_id)

        serializer = EditOrganizationSerializer(organization, data = request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status = status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @extend_schema(
        summary = 'Удаление организации',
        parameters = [
            OpenApiParameter(name = 'organization_id', description = 'Идентификатор организации', type = int, required = True, location = OpenApiParameter.PATH),
        ],
        responses = {(200, 'application/json'): OpenApiResponse(response = {'message': 'Объект удален'}, examples = [OpenApiExample('Пример', value = {'message': 'Объект удален'})])}
    )
    def delete(self, request, organization_id, *args, **kwargs):
        organization = GetOrganization(organization_id)
        organization.delete()
        return Response({'message': 'Объект удален'}, status = status.HTTP_200_OK)

@extend_schema(
    tags = ['Организации (Done)'],
)
class OrganizationsDeleteAPIView(APIView):
    permission_classes = [IsAdminUser,]

    @extend_schema(
        summary = 'Удаление нескольких организаций',
        description = '"id" - список идентификаторов организаций',
        request = OrganizationsDeleteSerializer(),
        responses = {(200, 'application/json'): OpenApiResponse(response = {'message': 'Элементы удалены'}, examples = [OpenApiExample('Пример', value = {'message': 'Элементы удалены'})])}
    )
    def post(self, request, *args, **kwargs):
        serializer = OrganizationsDeleteSerializer({'id': request.data.getlist('id')})
        if serializer:
            OrganizationModel.objects.filter(id__in = serializer.data.get('id')).delete()
            return Response({'message': 'Элементы удалены'}, status = status.HTTP_200_OK)
        return Response({'error': 'Некорректные данные'}, status = status.HTTP_400_BAD_REQUEST)

def GetOrganization(organization_id, relates = False):
    try:
        if relates:
            return OrganizationModel.objects.prefetch_related('contacts').get(id = organization_id)
        else:
            return OrganizationModel.objects.get(id = organization_id)
    except:
        raise APIException('Организация с id = ' + str(organization_id) + ' не найдена')

#Список пользователей
@extend_schema(
    tags = ['Пользователи (Done)'],
)

class UsersListAPIView(APIView):
    permission_classes = [IsAdminUser,]

    @extend_schema(
        summary='Список пользователей',
        description='<ol><li>"id" - Идентификатор пользователя</li>'
                    '<li>"email" - Адрес электронной почты пользователя</li>'
                    '<li>"organization_name" - Наименование организации пользователя</li>'
                    '<li>"phone" - Телефон пользователя</li>'
                    '<li>"last_login" - Дата последнего входа</li>'
                    '<li>"date_joined" - Дата регистрации</li>'
                    '<li>"groups" - Список наименований групп</li></ol>',
        responses={(200, 'application/json'): OpenApiResponse(response=UsersSerializer(many=True))}
    )
    def get(self, request, *args, **kwargs):
        # Параметры от DataTables
        draw = int(request.GET.get('draw', 1))
        start = int(request.GET.get('start', 0))
        length = int(request.GET.get('length', 10))
        search_value = request.GET.get('search[value]', '')

        # Базовый запрос
        queryset = User.objects.filter(~Q(email='serindework@mail.ru')) \
            .select_related('organization') \
            .prefetch_related('groups') \
            .annotate(organization_name=F('organization__name'))

        # Поиск
        if search_value:
            queryset = queryset.filter(
                Q(email__icontains=search_value) |
                Q(organization__name__icontains=search_value) |
                Q(phone__icontains=search_value) |
                Q(groups__name__icontains=search_value) |
                Q(last_login__icontains=search_value) |  # Добавлен поиск по last_login
                Q(date_joined__icontains=search_value)   # Добавлен поиск по date_joined
            ).distinct()

        # Общее количество записей (до пагинации)
        total_records = queryset.count()

        # Сортировка
        order_column = int(request.GET.get('order[0][column]', 0))
        order_dir = request.GET.get('order[0][dir]', 'asc')

        # Добавлены новые колонки для сортировки
        columns = ['id', 'email', 'organization_name', 'phone', 'last_login', 'date_joined', 'groups']
        order_field = columns[order_column]
        if order_dir == 'desc':
            order_field = f'-{order_field}'

        queryset = queryset.order_by(order_field)

        # Пагинация
        queryset = queryset[start:start + length]

        # Подготовка данных
        data = []
        for user in queryset:
            data.append({
                'id': user.id,
                'email': user.email,
                'organization_name': user.organization_name or '',
                'phone': user.phone or '',
                'last_login': user.last_login.strftime('%Y-%m-%d %H:%M:%S') if user.last_login else '',
                'date_joined': user.date_joined.strftime('%Y-%m-%d %H:%M:%S'),
                'groups': ', '.join([g.name for g in user.groups.all()])
            })

        response = {
            'draw': draw,
            'recordsTotal': total_records,
            'recordsFiltered': total_records,
            'data': data
        }

        return Response(response, status=status.HTTP_200_OK)

    @extend_schema(
        summary = 'Добавление пользователя',
        description = '<b>Внимание!!!</b> В примере указано поле <b>"password"</b> сериализатора, но сам метод требует <b>вместо этого поля</b> указывать <b>"password1" и "password2"</b>\
            <ol><li>"email" - Адрес электронной почты пользователя</li><li><b>"password1" - Пароль</b></li><li><b>"password2" - Подтверждение пароля</b></li>\
            <li>"first_name" - Имя пользователя</li><li>"last_name" - Фамилия пользователя</li><li>"inn" - ИНН пользователя</li>\
            <li>"organization" - Идентификатор организации пользователя</li><li>"address" - Адрес пользователя</li><li>"phone" - Телефон пользователя</li><li>"telegram" - Идентификатор пользователя в телеграме</li></ol>',
        request = AddUserSerializer(),
        responses = {(201, 'application/json'): OpenApiResponse(response = AddUserSerializer())}
    )
    def post(self, request, *args, **kwargs):
        data = request.data.copy()

        # Проверка паролей
        if 'password' not in data:
            if data['password1'] != data['password2']:
                return Response({'error': 'Пароли не совпадают'}, status=status.HTTP_406_NOT_ACCEPTABLE)
            data['password'] = data['password1']

        group_id = data.pop('add_group', None)

        # Создаем пользователя
        serializer = AddUserSerializer(data=data)
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        user = serializer.save()

        # Если указана группа - добавляем ее
        if group_id is not None:
            try:
                # Преобразуем group_id в список ID (даже если пришло одно значение)
                group_ids = [int(group_id)] if not isinstance(group_id, list) else [int(g) for g in group_id]

                # Создаем данные для обновления
                edit_data = {'groups': group_ids}

                # Используем сериализатор для обновления групп
                edit_serializer = EditUserSerializer(
                    instance=user,
                    data=edit_data,
                    partial=True
                )

                if edit_serializer.is_valid():
                    edit_serializer.save()
                else:
                    user.delete()
                    return Response(
                        edit_serializer.errors,
                        status=status.HTTP_400_BAD_REQUEST
                    )

            except (ValueError, TypeError) as e:
                user.delete()
                return Response(
                    {'error': 'Неверный формат ID группы'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            except Group.DoesNotExist:
                user.delete()
                return Response(
                    {'error': 'Указанная группа не существует'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            except Exception as e:
                user.delete()
                return Response(
                    {'error': f'Ошибка при добавлении группы: {str(e)}'},
                    status=status.HTTP_500_INTERNAL_SERVER_ERROR
                )

        return Response(serializer.data, status=status.HTTP_201_CREATED)

@extend_schema(
    tags = ['Пользователи (Done)'],
)
class EditUserAPIView(APIView):
    permission_classes = [IsAdminUser,]
    parser_classes = [JSONParser, NestedMultipartParser]

    @extend_schema(
        request = EditUserSerializer(),
        responses = {(200, 'application/json'): OpenApiResponse(response = EditUserSerializer())},
        summary = 'Изменение пользователя',
        description = '<ol><li>"email" - Адрес электронной почты пользователя</li><li>"organization" - Идентификатор организации пользователя</li>\
            <li>"first_name" - Имя пользователя</li><li>"last_name" - Фамилия пользователя</li><li>"is_superuser" - Статус суперпользователя</li>\
            <li>"is_staff" - Статус персонала</li><li>"is_active" - Активный</li><li>"inn" - ИНН пользователя</li>\
            <li>"address" - Адрес пользователя</li><li>"phone" - Телефон пользователя</li><li>"telegram" - Идентификатор пользователя в телеграме</li>\
            <li>"groups" - Список идентификаторов групп</li></ol>',
        parameters = [
            OpenApiParameter(name = 'user_id', description = 'Идентификатор пользователя', type = int, required = True, location = OpenApiParameter.PATH),
        ]
    )
    def put(self, request, user_id, *args, **kwargs):
        user = GetUser(user_id)
        serializer = EditUserSerializer(user, data = request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status = status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @extend_schema(
        summary = 'Удаление пользователя',
        parameters = [
            OpenApiParameter(name = 'user_id', description = 'Идентификатор пользователя', type = int, required = True, location = OpenApiParameter.PATH),
        ],
        responses = {(200, 'application/json'): OpenApiResponse(response = {'message': 'Объект удален'}, examples = [OpenApiExample('Пример', value = {'message': 'Объект удален'})])}
    )
    def delete(self, request, user_id, *args, **kwargs):
        user = GetUser(user_id)
        user.delete()
        return Response({'message': 'Объект удален'}, status = status.HTTP_200_OK)

@extend_schema(
    tags = ['Пользователи (Done)'],
)
class UsersDeleteAPIView(APIView):
    permission_classes = [IsAdminUser,]

    @extend_schema(
        summary = 'Удаление нескольких пользователей',
        description = '"id" - список идентификаторов пользователей',
        request = UsersDeleteSerializer(),
        responses = {(200, 'application/json'): OpenApiResponse(response = {'message': 'Элементы удалены'}, examples = [OpenApiExample('Пример', value = {'message': 'Элементы удалены'})])}
    )
    def post(self, request, *args, **kwargs):
        serializer = UsersDeleteSerializer({'id': request.data.getlist('id')})
        if serializer:
            User.objects.filter(id__in = serializer.data.get('id')).delete()
            return Response({'message': 'Элементы удалены'}, status = status.HTTP_200_OK)
        return Response({'error': 'Некорректные данные'}, status=status.HTTP_400_BAD_REQUEST)

def GetUser(user_id, relates = False):
    try:
        if relates:
            return User.objects.prefetch_related('groups').get(id = user_id)
        else:
            return User.objects.get(id = user_id)
    except:
        raise APIException('Пользователь с id = ' + str(user_id) + ' не найден')

#Список групп
@extend_schema(
    tags = ['Группы пользователей (Done)'],
)
class GroupsListAPIView(APIView):
    permission_classes = [IsAdminUser,]
    parser_classes = [JSONParser, NestedMultipartParser]

    @extend_schema(
        summary = 'Список групп',
        description = '<ol><li>"id" - Идентификатор группы</li><li>"name" - Наименование группы</li></ol> Реквизит "contains" в этом методе не используется',
        responses = {(200, 'application/json'): OpenApiResponse(response = GroupsSerializer(many = True))},
    )
    def get(self, request, *args, **kwargs):
        list = Group.objects.all()

        serializer = GroupsSerializer(list, many = True)
        return Response(serializer.data, status = status.HTTP_200_OK)

    @extend_schema(
        summary = 'Добавление группы',
        description = '<ol><li>"name" - Наименование группы</li><li>"permissions" - Список идентификаторов разрешений</li></ol>',
        request = EditGroupSerializer(),
        responses = {(201, 'application/json'): OpenApiResponse(response = EditGroupSerializer())},
    )
    def post(self, request, *args, **kwargs):
        serializer = EditGroupSerializer(data = request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status = status.HTTP_201_CREATED)
        return Response(serializer.errors, status = status.HTTP_400_BAD_REQUEST)

@extend_schema(
    tags = ['Группы пользователей (Done)'],
)
class GroupsListUserAPIView(APIView):
    @extend_schema(
        summary = 'Список групп с принадлежностью конкретному пользователю',
        description = '<ol><li>"id" - Идентификатор группы</li><li>"name" - Наименование группы</li><li>"contains" - Признак наличия пользователя в группе</li></ol>',
        parameters = [
            OpenApiParameter(name = 'user_id', description = 'Идентификатор пользователя', type = int, required = True, location = OpenApiParameter.PATH),
        ],
        responses = {(200, 'application/json'): OpenApiResponse(response = GroupsSerializer(many = True))},
    )
    def get(self, request, user_id, *args, **kwargs):
        list = Group.objects.all().annotate(
            contains = Value(False)
        )
        user = GetUser(user_id, True)
        if user:
            user_groups_ids = user.groups.all().values_list('id', flat = True)
            for group in list:
                if group.id in user_groups_ids:
                    group.contains = True

        serializer = GroupsSerializer(list, many = True)
        return Response(serializer.data, status = status.HTTP_200_OK)

@extend_schema(
    tags = ['Группы пользователей (Done)'],
)
class EditGroupAPIView(APIView):
    permission_classes = [IsAdminUser,]
    parser_classes = [JSONParser, NestedMultipartParser]

    @extend_schema(
        request = EditGroupSerializer(),
        responses = {(200, 'application/json'): OpenApiResponse(response = EditGroupSerializer())},
        summary = 'Изменение группы',
        description = '<ol><li>"name" - Наименование группы</li><li>"permissions" - Список идентификаторов разрешений</li></ol>',
        parameters = [
            OpenApiParameter(name = 'group_id', description = 'Идентификатор группы', type = int, required = True, location = OpenApiParameter.PATH),
        ]
    )
    def put(self, request, group_id, *args, **kwargs):
        group = GetGroup(group_id)
        serializer = EditGroupSerializer(group, data = request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status = status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @extend_schema(
        summary = 'Удаление группы',
        parameters = [
            OpenApiParameter(name = 'group_id', description = 'Идентификатор группы', type = int, required = True, location = OpenApiParameter.PATH),
        ],
        responses = {(200, 'application/json'): OpenApiResponse(response = {'message': 'Объект удален'}, examples = [OpenApiExample('Пример', value = {'message': 'Объект удален'})])}
    )
    def delete(self, request, group_id, *args, **kwargs):
        group = GetGroup(group_id)
        group.delete()
        return Response({'message': 'Объект удален'}, status = status.HTTP_200_OK)

@extend_schema(
    tags = ['Группы пользователей (Done)'],
)
class GroupsDeleteAPIView(APIView):
    permission_classes = [IsAdminUser,]

    @extend_schema(
        summary = 'Удаление нескольких групп',
        description = '"id" - список идентификаторов групп',
        request = GroupsDeleteSerializer(),
        responses = {(200, 'application/json'): OpenApiResponse(response = {'message': 'Элементы удалены'}, examples = [OpenApiExample('Пример', value = {'message': 'Элементы удалены'})])}
    )
    def post(self, request, *args, **kwargs):
        serializer = GroupsDeleteSerializer({'id': request.data.getlist('id')})
        if serializer:
            Group.objects.filter(id__in = serializer.data.get('id')).delete()
            return Response({'message': 'Элементы удалены'}, status = status.HTTP_200_OK)
        return Response({'error': 'Некорректные данные'}, status=status.HTTP_400_BAD_REQUEST)

def GetGroup(group_id, relates = False):
    try:
        if relates:
            return Group.objects.prefetch_related('permissions').get(id = group_id)
        else:
            return Group.objects.get(id = group_id)
    except:
        raise APIException('Группа с id = ' + str(group_id) + ' не найдена')

#Список разрешений
@extend_schema(
    tags = ['Разрешения (Done)'],
)
class PermissionsListAPIView(APIView):
    permission_classes = [IsAdminUser,]

    @extend_schema(
        summary = 'Список разрешений',
        description = '<ol><li>"id" - Идентификатор разрешения</li><li>"name" - Наименование разрешения</li><li>"application" - Наименование приложения разрешения</li></ol> Реквизит "contains" в этом методе не используется',
        responses = {(200, 'application/json'): OpenApiResponse(response = PermissionsSerializer(many = True))},
    )
    def get(self, request, *args, **kwargs):
        list = Permission.objects.all().annotate(application = F('content_type__app_label'))

        serializer = PermissionsSerializer(list, many = True)
        return Response(serializer.data, status = status.HTTP_200_OK)

@extend_schema(
    tags = ['Разрешения (Done)'],
)
class PermissionsListGroupAPIView(APIView):
    permission_classes = [IsAdminUser,]

    @extend_schema(
        summary = 'Список разрешений с принадлежностью группе',
        description = '<ol><li>"id" - Идентификатор разрешения</li><li>"name" - Наименование разрешения</li>\
        <li>"application" - Наименование приложения разрешения</li><li>"contains" - Признак наличия разрешения в группе</li></ol>',
        parameters = [
            OpenApiParameter(name = 'group_id', description = 'Идентификатор группы', type = int, required = True, location = OpenApiParameter.PATH),
        ],
        responses = {(200, 'application/json'): OpenApiResponse(response = PermissionsSerializer(many = True))},
    )
    def get(self, request, group_id, *args, **kwargs):
        list = Permission.objects.all().annotate(
            application = F('content_type__app_label'),
            contains = Value(False)
        )

        group = GetGroup(group_id, True)
        if group:
            group_permissions = group.permissions.values_list('id', flat = True)
            for permission in list:
                if permission.id in group_permissions:
                    permission.contains = True

        serializer = PermissionsSerializer(list, many = True)
        return Response(serializer.data, status = status.HTTP_200_OK)

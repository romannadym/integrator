from django.db.models import Q, F
from rest_framework import status, serializers
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import JSONParser
from rest_framework.permissions import IsAdminUser
from rest_framework.exceptions import APIException

from drf_spectacular.utils import extend_schema, OpenApiParameter, OpenApiExample, OpenApiResponse, inline_serializer

from integrator.apps.parsers import NestedMultipartParser

from contracts.api.serializers import *

from contracts.models import SupportLevelModel, ContractModel, ContractEquipmentModel

@extend_schema(
    tags = ['Уровни поддержки (Done)']
)
class SupportLevelsListAPIView(APIView):
    permission_classes = [IsAdminUser,]

    @extend_schema(
        summary = 'Список уровней поддержки',
        description = '<ol><li>"id" - Идентификатор уровня поддержки</li>\
        <li>"priority" - Приоритет отображения уровня (упорядочивание от меньшего к большему)</li>\
        <li>"name" - Наименование уровня поддержки</li></ol>',
        responses = {(200, 'application/json'): OpenApiResponse(response = SupportLevelSerializer(many = True))}
    )
    def get(self, request, *args, **kwargs):
        levels = SupportLevelModel.objects.all()
        serializer = SupportLevelSerializer(levels, many = True)
        return Response(serializer.data, status = status.HTTP_200_OK)

    @extend_schema(
        summary = 'Добавление уровня поддержки',
        description = '<ol><li>"priority" - Приоритет отображения уровня (упорядочивание от меньшего к большему)</li>\
        <li>"name" - Наименование уровня поддержки</li></ol>',
        request = SupportLevelSerializer(),
        responses = {(201, 'application/json'): OpenApiResponse(response = SupportLevelSerializer())}
    )
    def post(self, request, *args, **kwargs):
        serializer = SupportLevelSerializer(data = request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@extend_schema(
    tags = ['Уровни поддержки (Done)']
)
class SupportLevelEditAPIView(APIView):
    permission_classes = [IsAdminUser,]

    @extend_schema(
        summary = 'Детальная информация об уровне поддержки',
        description = '<ol><li>"id" - Идентификатор уровня поддержки</li>\
        <li>"priority" - Приоритет отображения уровня (упорядочивание от меньшего к большему)</li>\
        <li>"name" - Наименование уровня поддержки</li></ol>',
        parameters = [
            OpenApiParameter(name = 'level_id', description = 'Идентификатор уровня поддержки', type = int, required = True, location = OpenApiParameter.PATH),
        ],
        responses = {(200, 'application/json'): OpenApiResponse(response = SupportLevelSerializer())}
    )
    def get(self, request, level_id, *args, **kwargs):
        level = GetSupportLevel(level_id)
        serializer = SupportLevelSerializer(level)
        return Response(serializer.data, status = status.HTTP_200_OK)

    @extend_schema(
        summary = 'Изменение уровня поддержки',
        request = SupportLevelSerializer(),
        description = '<ol><li>"priority" - Приоритет отображения уровня (упорядочивание от меньшего к большему)</li>\
        <li>"name" - Наименование уровня поддержки</li></ol>',
        parameters = [
            OpenApiParameter(name = 'level_id', description = 'Идентификатор уровня поддержки', type = int, required = True, location = OpenApiParameter.PATH),
        ],
        responses = {(200, 'application/json'): OpenApiResponse(response = SupportLevelSerializer())}
    )
    def put(self, request, level_id, *args, **kwargs):
        level = GetSupportLevel(level_id)
        serializer = SupportLevelSerializer(level, data = request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status = status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @extend_schema(
        summary = 'Удаление уровня поддержки',
        parameters = [
            OpenApiParameter(name = 'level_id', description = 'Идентификатор уровня поддержки', type = int, required = True, location = OpenApiParameter.PATH),
        ],
        responses = {(200, 'application/json'): OpenApiResponse(response = {'message': 'Элемент удален'}, examples = [OpenApiExample('Пример', value = {'message': 'Элемент удален'})])}
    )
    def delete(self, request, level_id, *args, **kwargs):
        level = GetSupportLevel(level_id)
        level.delete()
        return Response({'message': 'Элемент удален'}, status = status.HTTP_200_OK)

def GetSupportLevel(level_id):
    try:
        return SupportLevelModel.objects.get(id = level_id)
    except:
        raise APIException('Уровень поддержки с id = ' + str(level_id) + ' не найден')

@extend_schema(
    tags = ['Договоры (Done)']
)
class ContractsListAPIView(APIView):
    permission_classes = [IsAdminUser,]
    parser_classes = [JSONParser, NestedMultipartParser]

    @extend_schema(
        summary='Список договоров (для DataTables)',
        description='''<ol>
            <li>Возвращает данные в формате, совместимом с jQuery DataTables</li>
            <li>Поддерживает серверную обработку: пагинацию, сортировку и фильтрацию</li>
        </ol>''',
        parameters=[
            OpenApiParameter(name='draw', type=int, description='Счетчик запросов DataTables'),
            OpenApiParameter(name='start', type=int, description='Индекс первой записи'),
            OpenApiParameter(name='length', type=int, description='Количество записей на странице'),
            OpenApiParameter(name='search[value]', type=str, description='Строка поиска'),
            OpenApiParameter(name='order[0][column]', type=int, description='Индекс сортируемой колонки'),
            OpenApiParameter(name='order[0][dir]', type=str, description='Направление сортировки (asc/desc)'),
        ],
        responses={
            200: OpenApiResponse(
                description='Данные для DataTables',
                response=inline_serializer(
                    name='DataTablesResponse',
                    fields={
                        'draw': serializers.IntegerField(),
                        'recordsTotal': serializers.IntegerField(),
                        'recordsFiltered': serializers.IntegerField(),
                        'data': ContractListSerializer(many=True)
                    }
                )
            )
        }
    )
    def get(self, request, *args, **kwargs):
        # Получаем параметры от DataTables
        draw = int(request.GET.get('draw', 1))
        start = int(request.GET.get('start', 0))
        length = int(request.GET.get('length', 10))
        search_value = request.GET.get('search[value]', '')

        # Базовый запрос
        queryset = ContractModel.objects.annotate(
            organization_name=F('client__organization__name')
        ).values('id', 'number', 'organization_name', 'signed', 'enddate')

        # Применяем поиск
        if search_value:
            queryset = queryset.filter(
                Q(number__icontains=search_value) |
                Q(organization_name__icontains=search_value)
            )

        # Получаем общее количество записей (до фильтрации)
        records_total = ContractModel.objects.count()

        # Получаем количество отфильтрованных записей
        records_filtered = queryset.count()

        # Применяем сортировку
        order_column = request.GET.get('order[0][column]', '0')
        order_dir = request.GET.get('order[0][dir]', 'asc')

        # Маппинг колонок DataTables на поля модели
        column_map = {
            '0': 'id',
            '1': 'number',
            '2': 'organization_name',
            '3': 'signed',
            '4': 'enddate'
        }

        order_field = column_map.get(order_column, 'id')
        if order_dir == 'desc':
            order_field = f'-{order_field}'

        queryset = queryset.order_by(order_field)

        # Применяем пагинацию
        queryset = queryset[start:start + length]

        # Формируем ответ в формате DataTables
        response_data = {
            'draw': draw,
            'recordsTotal': records_total,
            'recordsFiltered': records_filtered,
            'data': list(queryset)
        }

        return Response(response_data, status=status.HTTP_200_OK)

    @extend_schema(
        summary = 'Добавление договора',

        description = '<ol><li>"number" - Номер договора</li><li>"client" - Идентификатор поставщика</li>\
        <li>"end_user" - Идентификатор конечного пользователя</li><li>"dc_address" - Адрес ЦОД</li>\
        <li>"signed" - Дата начала договора <b>в формате dd.mm.yyyy</b></li><li>"enddate" - Дата окончания договора <b>в формате dd.mm.yyyy</b></li>\
        <li>"link" - Ссылка на договор</li><li>"eqcontracts" - Список оборудования договора, где<ul>\
        <li>"id" - Идентификатор привязки оборудования к договору <b>(Не используется в данном методе, указывать не нужно)</b></li>\
        <li>"sn" - Серийный номер оборудования</li><li>"equipment" - Идентификатор оборудования</li>\
        <li>"support" - Идентификатор уровня поддержки</li><li>"DELETE" - True, если необходимо убрать привязку оборудования к договору</li></ul></li></ol>',
        request = ContractDetailsSerializer(),
        responses = {(201, 'application/json'): OpenApiResponse(response = ContractDetailsSerializer())}
    )
    def post(self, request, *args, **kwargs):
        serializer = ContractDetailsSerializer(data = request.data)

        if serializer.is_valid():
            serializer.save()
            return Response({'message': 'Элемент создан'}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@extend_schema(
    tags = ['Договоры (Done)']
)

class EqContractsEditAPIView(APIView):
    permission_classes = [IsAdminUser, ]
    parser_classes = [JSONParser, NestedMultipartParser]

    @extend_schema(
        summary='Список оборудования контракта',
        description='<ol><li>"id" - Идентификатор договора</li><li>"number" - Номер договора</li><li>"client" - Идентификатор поставщика</li>'
                    '<li>"end_users" - Список идентификаторов конечных пользователей</li><li>"dc_address" - Адрес ЦОД</li>'
                    '<li>"signed" - Дата начала договора в формате dd.mm.yyyy</li><li>"enddate" - Дата окончания договора в формате dd.mm.yyyy</li>'
                    '<li>"link" - Ссылка на договор</li><li>"eqcontracts" - Оборудование по договору (с пагинацией)</li></ol>',
        parameters=[
            OpenApiParameter(name='contract_id', description='Идентификатор договора', type=int, required=True, location=OpenApiParameter.PATH),
            OpenApiParameter(name='draw', description='Номер запроса DataTables', type=int, required=False, location=OpenApiParameter.QUERY),
            OpenApiParameter(name='start', description='Индекс первой записи', type=int, required=False, location=OpenApiParameter.QUERY),
            OpenApiParameter(name='length', description='Количество записей на странице', type=int, required=False, location=OpenApiParameter.QUERY),
            OpenApiParameter(name='search[value]', description='Поисковый запрос', type=str, required=False, location=OpenApiParameter.QUERY),
            OpenApiParameter(name='order[0][column]', description='Номер столбца для сортировки', type=int, required=False, location=OpenApiParameter.QUERY),
            OpenApiParameter(name='order[0][dir]', description='Направление сортировки (asc/desc)', type=str, required=False, location=OpenApiParameter.QUERY),
        ],
        responses={
            (200, 'application/json'): OpenApiResponse(response=ContractDetailsSerializer())
        }
    )
    def get(self, request, contract_id, *args, **kwargs):
        contract = GetContract(contract_id)
        # Получаем параметры от DataTables
        draw = int(request.query_params.get('draw', 1))
        start = int(request.query_params.get('start', 0))
        length = int(request.query_params.get('length', 10))
        search_value = request.query_params.get('search[value]', '')

        # Получаем список оборудования
        eqcontracts = contract.eqcontracts.all()

        # Применяем поиск
        if search_value:
            eqcontracts = eqcontracts.filter(
                Q(sn__icontains=search_value) |
                Q(equipment__name__icontains=search_value) |
                Q(support__name__icontains=search_value)
                )

        # Применяем сортировку (если параметры указаны)
        order_column = request.query_params.get('order[0][column]')
        order_dir = request.query_params.get('order[0][dir]', 'asc')
        default_order = 'id'  # Сортировка по умолчанию

        if order_column is not None:
            order_column = int(order_column)
            # Маппинг столбцов DataTables на поля модели
            column_mapping = {
                0: 'id',
                1: 'sn',
                2: 'equipment__name',
                3: 'support__name',
            }
            if order_column in column_mapping:
                order_field = column_mapping[order_column]
                if order_dir == 'desc':
                    order_field = f'-{order_field}'
                eqcontracts = eqcontracts.order_by(order_field)
            else:
                # Если номер столбца не найден в маппинге, используем сортировку по умолчанию
                eqcontracts = eqcontracts.order_by(default_order)
        else:
            # Если параметры сортировки не указаны, используем сортировку по умолчанию
            eqcontracts = eqcontracts.order_by(default_order)

        # Получаем общее количество записей (до пагинации)
        records_total = contract.eqcontracts.count()
        records_filtered = eqcontracts.count()

        # Применяем пагинацию
        eqcontracts = eqcontracts[start:start + length]

        # Сериализуем данные (предполагая, что у вас есть EquipmentSerializer)
        serializer = EquipmentSerializer(eqcontracts, many=True)

        # Формируем ответ в формате DataTables
        response_data = {
            'draw': draw,
            'recordsTotal': records_total,
            'recordsFiltered': records_filtered,
            'data': serializer.data,  # Используем сериализованные данные
            'contract': {
                'id': contract.id,
                'number': contract.number,
                'signed': contract.signed.strftime('%d.%m.%Y') if contract.signed else None,
                'enddate': contract.enddate.strftime('%d.%m.%Y') if contract.enddate else None,
                'client': contract.client_id,
                'end_users': list(contract.end_users.values_list('id', flat=True)),
            }
        }

        return Response(response_data, status=status.HTTP_200_OK)

    @extend_schema(
    summary='Добавить оборудование к договору',
    description='Добавляет новое оборудование к указанному договору',
    request=EquipmentCreateSerializer,
    responses={
            201: OpenApiResponse(description='Оборудование успешно добавлено', response=EquipmentSerializer()),
            400: OpenApiResponse(description='Неверные данные'),
            404: OpenApiResponse(description='Договор не найден')
        }
    )
    def post(self, request, contract_id, *args, **kwargs):
        try:
            # Получаем договор и убеждаемся, что он существует
            contract = ContractModel.objects.get(pk=contract_id)
        except ContractModel.DoesNotExist:
            return Response(
                {'error': 'Договор не найден'},
                status=status.HTTP_404_NOT_FOUND
            )

        # Создаем копию данных запроса
        data = request.data.copy()
        
        # Добавляем contract в данные, а не contract_id
        data['contract'] = contract.id  # Здесь используется ID договора

        serializer = EquipmentCreateSerializer(data=data)
        if serializer.is_valid():
            try:
                # Сохраняем оборудование с привязкой к договору
                equipment = serializer.save()
                response_serializer = EquipmentSerializer(equipment)
                return Response(
                    response_serializer.data,
                    status=status.HTTP_201_CREATED
                )
            except IntegrityError as e:
                return Response(
                    {'error': str(e)},
                    status=status.HTTP_400_BAD_REQUEST
                )

        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )

class ContractsEditAPIView(APIView):
    permission_classes = [IsAdminUser, ]
    parser_classes = [JSONParser, NestedMultipartParser]

    @extend_schema(
        summary='Детальная информация о договоре',
        description='<ol><li>"id" - Идентификатор договора</li><li>"number" - Номер договора</li><li>"client" - Идентификатор поставщика</li>'
                    '<li>"end_users" - Список идентификаторов конечных пользователей</li><li>"dc_address" - Адрес ЦОД</li>'
                    '<li>"signed" - Дата начала договора в формате dd.mm.yyyy</li><li>"enddate" - Дата окончания договора в формате dd.mm.yyyy</li>'
                    '<li>"link" - Ссылка на договор</li></ol>',
        parameters=[
            OpenApiParameter(name='contract_id', description='Идентификатор договора', type=int, required=True, location=OpenApiParameter.PATH),
        ],
        responses={(200, 'application/json'): OpenApiResponse(response=ContractDetailsSerializer())}
    )
    def get(self, request, contract_id, *args, **kwargs):
        contract = GetContract(contract_id)
        serializer = ContractDetailsSerializer(contract)
        is_datatable_request = request.query_params.get('datatables') == 'true'
        if is_datatable_request:
            # Обработка запроса от DataTables для eqcontracts
            return Response(serializer.data.eqcontracts, status=status.HTTP_200_OK)
        else:
            return Response(serializer.data, status=status.HTTP_200_OK)

    @extend_schema(
        summary='Изменение договора',
        description='<ol><li>"number" - Номер договора</li><li>"client" - Идентификатор поставщика</li>'
                    '<li>"end_users" - Список идентификаторов конечных пользователей</li><li>"dc_address" - Адрес ЦОД</li>'
                    '<li>"signed" - Дата начала договора <b>в формате dd.mm.yyyy</b></li><li>"enddate" - Дата окончания договора <b>в формате dd.mm.yyyy</b></li>'
                    '<li>"link" - Ссылка на договор</li></ol>',
        parameters=[
            OpenApiParameter(name='contract_id', description='Идентификатор договора', type=int, required=True, location=OpenApiParameter.PATH),
        ],
        request=ContractDetailsSerializer(),
        responses={(200, 'application/json'): OpenApiResponse(response=ContractDetailsSerializer())}
    )
    def put(self, request, contract_id, *args, **kwargs):
        contract = GetContract(contract_id)
        serializer = ContractDetailsSerializer(contract, data=request.data)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @extend_schema(
        summary='Удаление договора',
        parameters=[
            OpenApiParameter(name='contract_id', description='Идентификатор договора', type=int, required=True, location=OpenApiParameter.PATH),
        ],
        responses={(200, 'application/json'): OpenApiResponse(response={'message': 'Элемент удален'}, examples=[OpenApiExample('Пример', value={'message': 'Элемент удален'})])}
    )
    def delete(self, request, contract_id, *args, **kwargs):
        contract = GetContract(contract_id)
        contract.delete()
        return Response({'message': 'Элемент удален'}, status=status.HTTP_200_OK)

class ContractsDeleteAPIView(APIView):
    permission_classes = [IsAdminUser,]

    @extend_schema(

        summary = 'Удаление списка договоров',
        description = 'Используется метод POST, т.к. методом DELETE невозможно отправить тело запроса\
        <p>"id" - Список идентификаторов договоров { "id": [1, 2, 3] }</p>',
        request = ContractsDeleteSerializer(),
        responses = {(200, 'application/json'): OpenApiResponse(response = {'message': 'Элементы удалены'}, examples = [OpenApiExample('Пример', value = {'message': 'Элементы удалены'})])}

    )
    def post(self, request, *args, **kwargs):
        serializer = ContractsDeleteSerializer({'id': request.data.getlist('id')})
        if serializer:
            ContractModel.objects.filter(id__in = serializer.data.get('id')).delete()
            return Response({'message': 'Элементы удалены'}, status = status.HTTP_200_OK)
        return Response({'error': 'Некорректные данные'}, status=status.HTTP_400_BAD_REQUEST)

def GetContract(contract_id):
    try:
        contract = ContractModel.objects.prefetch_related('eqcontracts').get(id = contract_id)
    except ContractModel.DoesNotExist:

        return Response({'message': 'DoesNotExist'}, status = status.HTTP_400_BAD_REQUEST)

    return contract

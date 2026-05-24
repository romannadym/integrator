from rest_framework import serializers

from contracts.models import SupportLevelModel, ContractModel, ContractEquipmentModel, ContractEndUser
from equipments.models import EquipmentModel
from django.contrib.auth import get_user_model
User = get_user_model()  # Правильный способ получить модель пользователя
class SupportLevelSerializer(serializers.ModelSerializer):
    priority = serializers.IntegerField(default = 0)
    class Meta:
        model = SupportLevelModel
        fields = '__all__'

class EquipmentSerializer(serializers.ModelSerializer):
    id = serializers.IntegerField(label = 'Идентификатор', required = False)
    DELETE = serializers.BooleanField(label = 'Удалить', default = False, required = False)
    equipment_name = serializers.SerializerMethodField()
    support_name = serializers.CharField(source='support.name', read_only=True)
    class Meta:
        model = ContractEquipmentModel
        fields = ['id', 'sn', 'equipment', 'equipment_name', 'support', 'support_name', 'DELETE']
    def get_equipment_name(self, obj):
        """Получаем полное название оборудования через связанные модели"""
        if obj.equipment:
            parts = []
            if obj.equipment.brand:
                parts.append(obj.equipment.brand.name)
            if obj.equipment.model:
                parts.append(obj.equipment.model.name)
            #if obj.equipment.type:
                #parts.append(obj.equipment.type.name)
            return ' '.join(parts) if parts else obj.equipment.name
        return None

class ContractDetailsSerializer(serializers.ModelSerializer):
    eqcontracts = EquipmentSerializer(many = True, required = False)
    signed = serializers.DateField(label = 'Начало договора', format = '%d.%m.%Y')
    enddate = serializers.DateField(label = 'Окончание договора', format = '%d.%m.%Y')
    end_user_organization = serializers.IntegerField(write_only=True, required=False)

    class Meta:
        model = ContractModel
        fields = '__all__'
        extra_kwargs = {
            'eqcontracts': {'required': False},  # Делаем поле необязательным
        }

    def create(self, validated_data):
        print(f"DEBUG VALIDATED DATA: {validated_data}")
        # Извлекаем данные
        equipments = validated_data.pop('eqcontracts', [])
        # end_user_organization теперь содержит ID выбранной организации
        organization_id = validated_data.pop('end_user_organization', None)
        print(f"DEBUG ORG_ID: {organization_id}")
        # Создаем основной контракт
        contract = ContractModel.objects.create(**validated_data)

        # Работаем с Конечным пользователем (промежуточная таблица)
        if organization_id:
            # Создаем запись напрямую в ContractEndUser
            # Используем заглушку user_id=1, как договаривались ранее
            new_link = ContractEndUser.objects.create(
                contractmodel=contract,
                organization_id=organization_id,
                user_id=1
            )
            print(f"DEBUG LINK CREATED: {new_link.id}")
        else:
            print("DEBUG: organization_id is MISSING in validated_data")

        # Работаем с оборудованием (bulk_create)
        if equipments:
            equipments_instance = []
            for equipment in equipments:
                # Убеждаемся, что DELETE есть в словаре перед тем как делать pop
                if not equipment.get('DELETE', False):
                    equipment.pop('DELETE', None)
                    equipments_instance.append(
                        ContractEquipmentModel(**equipment, contract=contract)
                    )
            if equipments_instance:
                ContractEquipmentModel.objects.bulk_create(equipments_instance)

        return contract

    def update(self, instance, validated_data):
        # 1. Извлекаем организацию (этого поля нет в модели ContractModel)
        org_id = validated_data.pop('end_user_organization', None)
        equipments = validated_data.pop('eqcontracts', [])

        # 2. Обновляем поля самой модели (client теперь ForeignKey на организацию)
        # Убрал end_user_organization из списка fields для setattr
        fields = ['number', 'organization', 'dc_addres', 'signed', 'enddate', 'link']
        for field in fields:
            if field in validated_data:
                setattr(instance, field, validated_data.get(field))
        instance.save()

        # 3. Обновляем Конечного пользователя
        if org_id:
            # Обновляем или создаем связь
            ContractEndUser.objects.update_or_create(
                contractmodel=instance,
                defaults={'organization_id': org_id, 'user_id': 1}
            )

        equipments = validated_data.pop('eqcontracts')
        if equipments:
            equipments_create = []
            equipments_update = []
            equipments_delete = []
            for equipment in equipments:
                if equipment['DELETE'] and 'id' in equipment.keys():
                    equipments_delete.append(equipment['id'])
                elif not equipment['DELETE']:
                    equipment.pop('DELETE')

                    if 'id' in equipment.keys():
                        equipments_update.append(ContractEquipmentModel(**equipment))
                    else:
                        equipments_create.append(ContractEquipmentModel(**equipment, contract = instance))

            if equipments_delete:
                ContractEquipmentModel.objects.filter(id__in = equipments_delete, contract = instance).delete()
            if equipments_create:
                ContractEquipmentModel.objects.bulk_create(equipments_create, ignore_conflicts = True)
            if equipments_update:
                ContractEquipmentModel.objects.bulk_update(equipments_update, ['equipment', 'sn', 'support'])
            # Сохранение конечных пользователей
            end_users = validated_data.pop('end_users', [])
            instance.end_users.set(end_users)
            return instance

class ContractsDeleteSerializer(serializers.ModelSerializer):
    id = serializers.ListField(label = 'Идентификатор', child = serializers.IntegerField(), required = True)
    class Meta:
        model = ContractModel
        fields = ['id']

class ContractListSerializer(serializers.ModelSerializer):
    organization_name = serializers.CharField(label = 'Наименование организации')
    class Meta:
        model = ContractModel
        fields = ['id', 'number', 'organization_name', 'signed', 'enddate']

class EquipmentCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = ContractEquipmentModel
        fields = ['equipment', 'sn', 'support', 'contract']  # Добавлено contract
        extra_kwargs = {
            'equipment': {'required': True},
            'sn': {'required': True},
            'support': {'required': True},
            'contract': {'required': True}  # Убедитесь, что contract обязателен
        }
class EquipmentUpdateSerializer(serializers.ModelSerializer):
     # Поле для выбора нового оборудования (по ID)
    new_equipment_id = serializers.PrimaryKeyRelatedField(
        queryset=EquipmentModel.objects.all(),
        write_only=True,
        required=False,
        label='Новое оборудование'
    )

    class Meta:
        model = ContractEquipmentModel  # Или ваша модель оборудования
        fields = ['support', 'sn', 'new_equipment_id']  # Только поле для уровня поддержки
        extra_kwargs = {
            'support': {'required': True},
            'sn': {'required': True}
        }

    def update(self, instance, validated_data):
        # 1. Меняем оборудование, если передан new_equipment_id
        new_equipment = validated_data.get('new_equipment_id')
        if new_equipment is not None:
            instance.equipment = new_equipment

        # 2. Обновляем остальные поля
        instance.sn = validated_data.get('sn', instance.sn)
        instance.support = validated_data.get('support', instance.support)

        instance.save()
        return instance

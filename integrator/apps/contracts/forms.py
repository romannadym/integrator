from django import forms
from django.forms.models import inlineformset_factory
from django.contrib.auth import get_user_model
from django.db.models import Q
from django_select2 import forms as s2forms
from contracts.models import SupportLevelModel, ContractModel, ContractEquipmentModel, ContractEndUser
from accounts.models import OrganizationModel
User = get_user_model()

class LevelForm(forms.ModelForm):
    class Meta:
        model = SupportLevelModel
        fields = '__all__'

class LevelDeleteForm(forms.ModelForm):
    class Meta:
        model = SupportLevelModel
        fields = []

class ClientWidget(s2forms.ModelSelect2Widget):
    search_fields = [
        'organization__name__icontains',
    ]
    def label_from_instance(self, obj):
        return str(obj.organization)

class ClientMultipleWidget(s2forms.ModelSelect2Widget):
    search_fields = [
        'organization__name__icontains',
    ]
    def label_from_instance(self, obj):
        return str(obj.organization)
    def value_from_datadict(self, data, files, name):
        if name in data:
            # Преобразуем полученные данные в список строковых значений
            return data.getlist(name)
        return []
# class DateInput(forms.DateInput):
#     input_type = 'date'

class ContractForm(forms.ModelForm):
    # client = forms.ModelChoiceField(label = 'Заказчик', queryset = User.objects.filter(Q(is_active = True) & ~Q(email = 'serindework@mail.ru')))
    # end_user = forms.ModelChoiceField(label = 'Конечный пользователь', queryset = User.objects.filter(Q(is_active = True) & ~Q(email = 'serindework@mail.ru')))
    # Теперь это поле выбора ОРГАНИЗАЦИИ, а не пользователя
    end_user_organization = forms.ModelChoiceField(
        label='Конечный пользователь (Организация)',
        queryset=OrganizationModel.objects.all(),
        widget=s2forms.ModelSelect2Widget(
            model=OrganizationModel,
            search_fields=['name__icontains'],
            attrs={'class': 'form-select', 'data-minimum-input-length': 0, 'data-allow-clear': 'false'}
        ),
        required=False
    )
    class Meta:
        model = ContractModel
        # Исключаем end_users из автоматической обработки, так как мы добавили кастомное поле end_user
        exclude = ('end_users', 'client')
        fields = '__all__'
        labels = {
        'organization': 'Заказчик (Организация)',
        }
        widgets = {
            'organization': s2forms.ModelSelect2Widget(
                model=OrganizationModel,
                queryset=OrganizationModel.objects.all(),
                search_fields=['name__icontains'],
                attrs={'class': 'form-control', 'data-minimum-input-length': 0, 'data-allow-clear': 'false'}
            ),
            # 'client': forms.Select(queryset = User.objects.filter(Q(is_active = True) & ~Q(email = 'serindework@mail.ru'))),
            'signed': forms.DateInput(attrs = {'class': 'date'}),
            'enddate': forms.DateInput(attrs = {'class': 'date'}),
        }
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        if self.instance.pk:
            # Подтягиваем организацию из таблицы связей
            link = ContractEndUser.objects.filter(contractmodel=self.instance).first()
            if link and link.organization_id:
                self.initial['end_user_organization'] = link.organization_id

class ContractDeleteForm(forms.ModelForm):
    class Meta:
        model = ContractModel
        fields = []

class EquipmentWidget(s2forms.ModelSelect2Widget):
    search_fields = [
        'type__name__icontains',
        'brand__name__icontains',
        'model__name__icontains',
        'vendor__name__icontains',
    ]

class EquipmentForm(forms.ModelForm):
    class Meta:
        model = ContractEquipmentModel
        exclude = ['contract',]
        widgets = {
            'equipment': EquipmentWidget,
            'sn': forms.TextInput(attrs = {'placeholder': 'Серийный номер'}),
            'support': forms.Select(attrs = {'placeholder': 'Тип поддержки'}),
        }

EquipmentFormset = inlineformset_factory(
    ContractModel, ContractEquipmentModel,
    fields = '__all__',
    form = EquipmentForm,
    extra = 0
)

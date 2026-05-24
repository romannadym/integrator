from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from django.urls import reverse

from contracts.api.api import SupportLevelsListAPIView, SupportLevelEditAPIView
from contracts.api.api import ContractsListAPIView
from contracts.api.api import GetSupportLevel, GetContract

from contracts.forms import LevelForm, LevelDeleteForm, ContractForm, EquipmentForm, EquipmentFormset, ContractDeleteForm
from accounts.forms import  ContactForm
from integrator.apps.functions import is_admin_or_engineer
from django.contrib.auth import get_user_model

from contracts.models import ContractEndUser

@login_required
def SupportLevelsListView(request):
    if not request.user.groups.filter(name = 'Администратор').exists():
        return redirect('login', link = 'list-levels')

    items = SupportLevelsListAPIView.as_view()(request = request).data
    cols = ['Наименование',]

    context = {'items': items, 'cols': cols, 'label': 'Справочник "Тип поддержи"', 'add_link': 'add-level', 'edit_link': 'edit-level', 'model': 'SupportLevelModel'}

    return render(request, 'admin/list.html', context)

@login_required
def AddSupportLevelView(request):
    if not request.user.groups.filter(name = 'Администратор').exists():
        return redirect('login', link = 'list-levels')

    form = LevelForm()

    context = {'form': form, 'action': reverse('list-levels-api'), 'link': 'list-levels'}
    return render(request, 'admin/edit.html', context)

@login_required
def EditSupportLevelView(request, level_id):
    if not request.user.groups.filter(name = 'Администратор').exists():
        return redirect('login', link = 'list-levels')

    form = LevelForm(instance = GetSupportLevel(level_id))

    context = {'form': form, 'method': 'PUT', 'action': reverse('edit-level-api', kwargs = {'level_id': level_id}), 'link': 'list-levels', 'delete_link': 'delete-level'}
    return render(request, 'admin/edit.html', context)

@login_required
def DeleteSupportLevelView(request, level_id):
    if not request.user.groups.filter(name = 'Администратор').exists():
        return redirect('login', link = 'list-levels')

    form = LevelDeleteForm(instance = GetSupportLevel(level_id))

    context = {'form': form, 'action': reverse('edit-level-api', kwargs = {'level_id': level_id}), 'link': 'list-levels'}
    return render(request, 'admin/delete.html', context)

@login_required
def ContractsListView(request):
    permissions = {
        'is_admin': request.user.groups.filter(name='Администратор').exists(),
        'is_engineer': request.user.groups.filter(name='Инженер').exists(),
        'is_staff': is_admin_or_engineer(request.user)
    }
    if not request.user.groups.filter(name = 'Администратор').exists():
        return redirect('login', link = 'list-contracts')

    items = ContractsListAPIView.as_view()(request = request).data
    cols = ['Номер договора', 'Поставщик',]
    links = {
        'add_link': 'add-contract',
        'edit_link': 'edit-contract',
        'delete_link': 'contracts-delete-api',
    }
    form = ContractForm()
    formsets = [
        {'key': 'contacts', 'formset': [ContactForm()], 'label': 'Контактное лицо'},
    ]
    context = {'items': items, 'form':form, 'formsets': formsets, 'permissions': permissions, 'cols': cols, 'label': 'Контракты', 'links': links}

    return render(request, 'contracts/index.html', context)

@login_required
def AddContractView(request):
    if not request.user.groups.filter(name = 'Администратор').exists():
        return redirect('login', link = 'list-contracts')

    form = ContractForm()
    formset = EquipmentFormset()

    if request.method == 'POST':
        form = ContractForm(request.POST)
        if form.is_valid():
            contract = form.save(commit = False)
            formset = EquipmentFormset(request.POST, instance = contract)
            if formset.is_valid():
                contract.save()
                formset.save()
            return redirect('list-contracts')

    formsets = [
        {'formset': formset, 'label': 'Оборудование'},
    ]

    context = {'form': form, 'formsets': formsets, 'search': True, 'dates': True, 'action': reverse('list-contracts-api'), 'link': 'list-contracts'}
    return render(request, 'admin/edit_formset.html', context)

@login_required
def EditContractView(request, contract_id):
    permissions = {
        'is_admin': request.user.groups.filter(name='Администратор').exists(),
        'is_engineer': request.user.groups.filter(name='Инженер').exists(),
        'is_staff': is_admin_or_engineer(request.user)
    }
    if not request.user.groups.filter(name = 'Администратор').exists():
        return redirect('login', link = 'list-contracts')

    contract = GetContract(contract_id)
    form = ContractForm(instance = contract)
    formset = EquipmentFormset(instance = contract)

    if request.method == 'POST':
        form = ContractForm(request.POST, instance=contract)
        if form.is_valid():
            contract = form.save(commit=False)
            formset = EquipmentFormset(request.POST, instance=contract)

            if form.is_valid():
                contract = form.save(commit=False)
                # ... сохранение контракта и формсета ...

                org_obj = form.cleaned_data.get('end_user_organization')

                if org_obj:
                    # Ищем ЛЮБОГО активного пользователя из этой организации
                    # Теперь 'User' будет определен благодаря импорту выше
                    User = get_user_model()
                    user_obj = User.objects.filter(organization=org_obj, is_active=True).first()

                    # Если пользователя в организации вообще нет, можно либо выдать ошибку,
                    # либо (лучше) взять текущего админа/менеджера как тех. привязку
                    if not user_obj:
                        user_obj = request.user

                    # Обновляем или создаем связь в промежуточной таблице
                    link, created = ContractEndUser.objects.get_or_create(
                        contractmodel=contract,
                        defaults={'user': user_obj, 'organization': org_obj}
                    )
                    if not created:
                        link.organization = org_obj
                        link.user = user_obj
                        link.save()
                else:
                    # Если организация не выбрана — удаляем связь
                    ContractEndUser.objects.filter(contractmodel=contract).delete()
                # -------------------------------
                contract.save()
                formset.save()
                return redirect('list-contracts')

    formsets = [
        {'formset': formset, 'label': 'Оборудование'},
    ]

    context = {'form': form, 'formsets': formsets, 'search': True, 'dates': True, 'link': 'list-contracts', 'delete_link': 'delete-contract', 'permissions': permissions}
    return render(request, 'contracts/edit/edit.html', context)

@login_required
def DeleteContractView(request, contract_id):
    if not request.user.groups.filter(name = 'Администратор').exists():
        return redirect('login', link = 'list-contracts')

    contract = GetContract(contract_id)
    form = ContractDeleteForm(instance = contract)

    context = {'form': form, 'action': reverse('edit-contracts-api', kwargs = {'contract_id': contract_id}), 'link': 'list-contracts'}
    return render(request, 'admin/delete.html', context)

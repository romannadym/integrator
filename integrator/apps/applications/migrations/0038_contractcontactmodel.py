# Generated by Django 3.2.13 on 2022-11-18 09:53

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('applications', '0037_delete_contractcontactmodel'),
    ]

    operations = [
        migrations.CreateModel(
            name='ContractContactModel',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('fio', models.CharField(max_length=300, verbose_name='ФИО')),
                ('email', models.EmailField(max_length=254, unique=True, verbose_name='Адрес электронной почты')),
                ('phone', models.CharField(blank=True, max_length=18, null=True, verbose_name='Телефон')),
                ('contract', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='contacts', to='applications.contractmodel', verbose_name='Договор')),
            ],
            options={
                'verbose_name': 'Контактное лицо',
                'verbose_name_plural': 'Список контактных лиц',
            },
        ),
    ]

# Generated by Django 3.2.13 on 2023-05-23 11:27

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='TypeModel',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=200, verbose_name='Наименование')),
            ],
            options={
                'verbose_name': 'Тип оборудования',
                'verbose_name_plural': 'Типы оборудования',
                'ordering': ['name'],
            },
        ),
    ]

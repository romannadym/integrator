# Generated by Django 3.2.13 on 2023-05-23 07:49

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='PartNumberModel',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('number', models.CharField(max_length=100, verbose_name='Партномер')),
            ],
            options={
                'verbose_name': 'Партномер',
                'verbose_name_plural': 'Список партномеров',
                'ordering': ['number'],
            },
        ),
    ]

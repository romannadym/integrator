# Generated by Django 3.2.13 on 2022-10-06 12:08

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('accounts', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='telegram',
            field=models.CharField(blank=True, max_length=15, null=True, verbose_name='Идентификатор в телеграме'),
        ),
    ]

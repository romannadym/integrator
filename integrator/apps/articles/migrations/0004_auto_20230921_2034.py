# Generated by Django 3.2.13 on 2023-09-21 17:34

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('articles', '0003_articlemodel'),
    ]

    operations = [
        migrations.AlterField(
            model_name='articlemodel',
            name='header',
            field=models.TextField(verbose_name='Заголовок статьи'),
        ),
        migrations.AlterField(
            model_name='articlemodel',
            name='title',
            field=models.TextField(verbose_name='Заголовок'),
        ),
    ]

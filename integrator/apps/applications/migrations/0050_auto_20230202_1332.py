# Generated by Django 3.2.13 on 2023-02-02 13:32

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('applications', '0049_sparepartnumbermodel'),
    ]

    operations = [
        migrations.AlterField(
            model_name='sparepartnumbermodel',
            name='model',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='spmodelpns', to='applications.sparenamemodel', verbose_name='ЗИП'),
        ),
        migrations.AlterField(
            model_name='sparepnmodel',
            name='number',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='applications.sparepartnumbermodel', verbose_name='Партномер'),
        ),
    ]

# Generated by Django 3.2.13 on 2022-11-18 10:06

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('applications', '0040_applicationmodel_contact'),
    ]

    operations = [
        migrations.AlterField(
            model_name='applicationmodel',
            name='contact',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.PROTECT, related_name='appcontact', to='applications.contractcontactmodel', verbose_name='Контактное лицо'),
        ),
    ]

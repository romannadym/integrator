# Generated by Django 3.2.13 on 2022-10-13 10:25

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('applications', '0022_auto_20221013_1023'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='equipmentconfigmodel',
            name='contract',
        ),
    ]

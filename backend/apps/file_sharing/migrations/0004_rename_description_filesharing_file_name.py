# Generated by Django 4.1.7 on 2023-05-01 14:55

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('file_sharing', '0003_filesharing_bucket_name'),
    ]

    operations = [
        migrations.RenameField(
            model_name='filesharing',
            old_name='description',
            new_name='file_name',
        ),
    ]
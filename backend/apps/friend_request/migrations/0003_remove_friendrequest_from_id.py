# Generated by Django 4.1.7 on 2023-06-21 01:09

from django.db import migrations


class Migration(migrations.Migration):
    """Bypass check."""

    dependencies = [
        ("friend_request", "0002_friendrequest_friend_code_token_and_more"),
    ]

    operations = [
        migrations.RemoveField(
            model_name="friendrequest",
            name="from_id",
        ),
    ]

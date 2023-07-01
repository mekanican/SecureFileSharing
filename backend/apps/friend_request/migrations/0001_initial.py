# Generated by Django 4.1.7 on 2023-06-20 23:33

from django.db import migrations, models


class Migration(migrations.Migration):
    """Bypass check."""

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name="FriendRequest",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        primary_key=True,
                        serialize=False,
                        unique=True,
                    ),
                ),
                ("from_id", models.CharField(max_length=254)),
                ("friend_code", models.CharField(max_length=254, unique=True)),
                ("status", models.CharField(max_length=20)),
            ],
        ),
    ]

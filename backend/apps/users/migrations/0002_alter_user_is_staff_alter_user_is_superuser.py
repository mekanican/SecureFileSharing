# Generated by Django 4.1.7 on 2023-07-01 03:26

from django.db import migrations, models


class Migration(migrations.Migration):
    """Bypass check."""

    dependencies = [
        ("users", "0001_initial"),
    ]

    operations = [
        migrations.AlterField(
            model_name="user",
            name="is_staff",
            field=models.BooleanField(
                default=False,
                help_text=(
                    "Designates whether the user"
                    "can log into this admin site."
                ),
                verbose_name="Staff status"),
        ),
        migrations.AlterField(
            model_name="user",
            name="is_superuser",
            field=models.BooleanField(
                default=False,
                help_text=(
                    "Designates that this user has all permissions"
                    "without explicitly assigning them."),
                verbose_name="superuser status",
            ),
        ),
    ]

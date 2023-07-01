# pylint: disable=C0114
from django.apps import AppConfig


class UsersConfig(AppConfig):
    """App config for users app."""

    default_auto_field = "django.db.models.BigAutoField"
    name = "apps.users"

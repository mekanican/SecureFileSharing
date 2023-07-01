# pylint: disable=C0114

from django.apps import AppConfig


class KeysHandlerConfig(AppConfig):
    """App config for keys_handler app."""

    default_auto_field = "django.db.models.BigAutoField"
    name = "apps.keys_handler"

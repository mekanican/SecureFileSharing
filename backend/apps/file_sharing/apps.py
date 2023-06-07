from django.apps import AppConfig  # type: ignore


class FilesharingConfig(AppConfig):
    """App config for file_sharing app."""

    default_auto_field = "django.db.models.BigAutoField"
    name = "apps.file_sharing"

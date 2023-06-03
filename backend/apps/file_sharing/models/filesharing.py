# from apps.users.models import User
from django.contrib.auth import get_user_model
from django.db import models

User = get_user_model()


class FileSharing(models.Model):
    """File sharing model."""

    from_user = models.ForeignKey(
        User,
        related_name="from_user",
        on_delete=models.CASCADE,
    )

    to_user = models.ForeignKey(
        User,
        related_name="to_user",
        on_delete=models.CASCADE,
    )

    url = models.CharField(max_length=1000, blank=True, null=True)

    uploaded_at = models.DateTimeField(auto_now_add=True)

    def __str__(self) -> str:
        return f"{self.from_user} to {self.to_user} with URL {self.url}"

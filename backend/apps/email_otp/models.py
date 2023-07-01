
from django.db import models


class EmailOTP(models.Model):
    """Model for EmailOTP."""

    id = models.BigAutoField(primary_key=True, unique=True)
    email = models.CharField(max_length=254)
    date_verify = models.DateTimeField(blank=True, null=True)

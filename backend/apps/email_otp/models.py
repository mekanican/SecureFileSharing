
from django.db import models


class EmailOTP(models.Model):
    """Model for EmailOTP."""

    # null = False is the default, so we don't need to specify it.
    id = models.BigAutoField(primary_key=True, unique=True)
    email = models.CharField(max_length=254)
    date_verify = models.DateTimeField(blank=True, null=True)

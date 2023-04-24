from django.db import models

from .constants import MAX_SIGNATURE_LENGTH


class Signature(models.Model):
    """Model for storing signatures."""

    secret: models.BinaryField = models.BinaryField(
        max_length=MAX_SIGNATURE_LENGTH,
    )

    def generate_signature(self, data):
        """Generate signature for data."""
        self.secret = data

    def check_signature(self, data):
        """Check signature for data."""
        return self.secret == data

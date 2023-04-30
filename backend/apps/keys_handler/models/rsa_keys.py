# pylint: disable=C0114,invalid-name,import-error,wrong-import-order
import json

from apps.keys_handler.prime_numbers_handler.prime_numbers_generator import (
    generate_large_prime_number,
)
from django.contrib.auth import get_user_model
from django.db import models

User = get_user_model()


class RSAPublicKey(models.Model):
    """Model for RSA private key."""

    n: models.CharField = models.CharField(max_length=310)
    e: models.CharField = models.CharField(max_length=310)

    user: User = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        null=True,
    )

    def set_n(self, n):
        """Set n."""
        self.n = n

    def set_e(self, e):
        """Set e."""
        self.e = e

    def get_content(self):
        """Return a json representation of the object."""
        return json.dumps({
            "n": self.n,
            "e": self.e,
        })


class RSAPrivateKey(models.Model):
    """Model for RSA public key."""

    p: models.CharField = models.CharField(max_length=310)  # 2^1024 ~ 10^309
    q: models.CharField = models.CharField(max_length=310)
    d: models.CharField = models.CharField(max_length=310)

    user: User = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        null=True,
    )

    def generate_keys(self):
        """Generate RSA keys.

        p, q are large prime numbers.
        d is the private key.
        """
        # Generate 2 large prime numbers for p and q
        p = generate_large_prime_number()
        q = generate_large_prime_number()

        return p, q

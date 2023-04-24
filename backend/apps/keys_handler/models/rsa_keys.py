# pylint: disable=C0114,invalid-name,import-error,wrong-import-order
import json

from apps.keys_handler.prime_numbers_handler.prime_numbers_generator import (
    generate_large_prime_number,
)
from django.db import models


class RSAPrivateKey(models.Model):
    """Model for RSA private key."""

    n: models.BigIntegerField = models.BigIntegerField()
    e: models.BigIntegerField = models.BigIntegerField()

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


class RSAPublicKey(models.Model):
    """Model for RSA public key."""

    p: models.BigIntegerField = models.BigIntegerField()
    q: models.BigIntegerField = models.BigIntegerField()
    d: models.BigIntegerField = models.BigIntegerField()

    def generate_keys(self):
        """Generate RSA keys.

        p, q are large prime numbers.
        d is the private key.
        """
        # Generate 2 large prime numbers for p and q
        p = generate_large_prime_number()
        q = generate_large_prime_number()

        print(p, q)

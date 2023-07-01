# pylint: disable=too-few-public-methods
from rest_framework import serializers

from .models import RSAPrivateKey, RSAPublicKey


class RSAPublicKeySerializer(serializers.ModelSerializer):
    """Serializer for RSAPrivateKey model."""

    class Meta:

        model = RSAPublicKey
        fields = (
            "n",
            "e",
            "user",
        )


class RSAPrivateKeySerializer(serializers.ModelSerializer):
    """Serializer for RSAPublicKey model."""

    class Meta:

        model = RSAPrivateKey
        fields = (
            "p",
            "q",
            "d",
            "user",
        )

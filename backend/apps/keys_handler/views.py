# pylint: disable=wrong-import-order
import math
import random

from apps.keys_handler.prime_numbers_handler import generate_large_prime_number
from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.response import Response
from rest_framework.views import APIView

from .serializers import RSAPrivateKeySerializer, RSAPublicKeySerializer


class RSAKeyGenerateView(APIView):
    """API view for generating RSA public & private keys for a user."""

    def get(self, request):
        user_token = request.query_params.get("token")
        user = Token.objects.get(key=user_token).user

        p = generate_large_prime_number()
        q = generate_large_prime_number()
        n = p * q
        phi = (p - 1) * (q - 1)

        # Choose e such that e in [1, phi] and gcd(e, phi) = 1
        while True:
            e = random.randrange(1, phi)
            if math.gcd(e, phi) == 1:
                break

        # Choose d such that d in [1, phi] and e*d = 1 (mod phi)
        d = pow(e, -1, phi)

        # Save the keys in the database
        private_key_serializer = RSAPrivateKeySerializer(
            data={"p": p, "q": q, "d": d, "user": user.id},
        )
        public_key_serializer = RSAPublicKeySerializer(
            data={"n": n, "e": e, "user": user.id},
        )

        if (
            public_key_serializer.is_valid() and
            private_key_serializer.is_valid()
        ):
            public_key_serializer.save()
            private_key_serializer.save()
            return Response(
                {
                    "message": "Keys generated successfully",
                    "keys": {
                        "public": public_key_serializer.data,
                        "private": private_key_serializer.data,
                    },
                },
                status=status.HTTP_200_OK,
            )

        return Response(
            {
                "error": "Internal server error",
            },
            status=status.HTTP_500_INTERNAL_SERVER_ERROR,
        )

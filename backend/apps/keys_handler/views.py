# pylint: disable=wrong-import-order,no-member,invalid-name
import math
import random

from apps.keys_handler.prime_numbers_handler import generate_large_prime_number
from django.contrib.auth import get_user_model
from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import RSAPublicKey
from .serializers import RSAPrivateKeySerializer, RSAPublicKeySerializer

User = get_user_model()


class RSAKeyGenerateView(APIView):
    """API view for generating RSA public & private keys for a user."""

    def get(self, request) -> Response:
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
            # Find if this user has already generated public key,
            # if yes, delete it
            try:
                RSAPublicKey.objects.get(user=user).delete()
            except RSAPublicKey.DoesNotExist:
                pass

            public_key_serializer.save()

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


class RSAPublicKeyGetAPIView(APIView):
    """API view for getting RSA public key for a user."""

    def get(self, request) -> Response:
        user_token = request.query_params.get("token")
        try:
            _ = Token.objects.get(key=user_token).user
        except Token.DoesNotExist:
            return Response(
                {
                    "error": "Invalid token",
                },
                status=status.HTTP_400_BAD_REQUEST,
            )

        user_id = request.query_params.get("id")
        if not user_id:
            return Response(
                {
                    "error": "User id not provided",
                },
                status=status.HTTP_400_BAD_REQUEST,
            )

        try:
            user_with_that_id = User.objects.get(id=user_id)
        except User.DoesNotExist:
            return Response(
                {
                    "error": "User not found",
                },
                status=status.HTTP_404_NOT_FOUND,
            )

        try:
            public_key = RSAPublicKey.objects.get(user=user_with_that_id)
        except RSAPublicKey.DoesNotExist:
            return Response(
                {
                    "error": "Public key not found",
                },
                status=status.HTTP_404_NOT_FOUND,
            )

        return Response(
            {
                "message": "Public key found",
                "public_key": {
                    "n": public_key.n,
                    "e": public_key.e,
                },
            },
            status=status.HTTP_200_OK,
        )

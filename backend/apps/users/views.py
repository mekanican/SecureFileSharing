# pylint: disable=no-member,broad-exception-caught
from django.contrib.auth import authenticate
from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.response import Response
from rest_framework.views import APIView

from .serializers import UserSerializer


class UserRegisterView(APIView):
    """API view to register a new user."""

    def post(self, request) -> Response:
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            return Response(
                {"user_id": user.id},
                status=status.HTTP_201_CREATED,
            )
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST,
        )


class UserLoginView(APIView):
    """API view to login a user."""

    def post(self, request) -> Response:
        username = request.data.get("username")
        password = request.data.get("password")
        user = authenticate(username=username, password=password)
        if user:
            token, _ = Token.objects.get_or_create(user=user)
            return Response(
                {"token": token.key},
                status=status.HTTP_200_OK,
            )
        return Response(
            {"error": "Invalid credentials"},
            status=status.HTTP_400_BAD_REQUEST,
        )


class UserLogoutView(APIView):
    """API view for user logout."""

    def get(self, request) -> Response:
        try:
            # get the token from the url
            token_key = request.query_params.get("token")

            # delete the token
            Token.objects.get(key=token_key).delete()

            # return success response
            return Response(status=status.HTTP_200_OK)
        except Exception:
            # return error response
            return Response(status=status.HTTP_400_BAD_REQUEST)

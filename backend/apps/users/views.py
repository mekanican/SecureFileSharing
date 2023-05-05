
# pylint: disable=no-member,broad-exception-caught
from django.contrib.auth import authenticate, get_user_model
from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.response import Response
from rest_framework.views import APIView
from asgiref.sync import async_to_sync,sync_to_async
from ..email_otp.models import EmailOTP
from ..email_otp.views import SendEmailHandler
from .serializers import UserSerializer

User = get_user_model()


class UserRegisterView(APIView):
    """API view to register a new user."""

    def post(self, request) -> Response:

        cloneRequest = request
        serializer = UserSerializer(data=cloneRequest.data)
        if serializer.is_valid():
            user = serializer.save()
            email_otp = EmailOTP(id=user.id, email=user.email)
            email_otp.save()
            sync_to_async(SendEmailHandler.SendMail)(cloneRequest, user)
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

        try:
            q1 = User.objects.get(username=user)
            email_otp = EmailOTP.objects.get(id=q1.id, email=q1.email)
            # print(email_otp.date_verify)
        except User.DoesNotExist:
            return Response(
                {"error": "Invalid username"},
                status=status.HTTP_400_BAD_REQUEST,
            )

        if user and email_otp.date_verify:
            token, _ = Token.objects.get_or_create(user=user)
            return Response(
                {"token": token.key},
                status=status.HTTP_200_OK,
            )
        else:
            if user:
                return  Response(
                {"error":"Unverified email"},
                status=status.HTTP_400_BAD_REQUEST,)
        
        return  Response(
            {"error":"Invalid credentials"},
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

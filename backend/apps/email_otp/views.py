import os
from datetime import datetime, timedelta

import jwt
from django.core.mail import send_mail
from django.shortcuts import render
from django.template.loader import render_to_string
from dotenv import load_dotenv
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import EmailOTP

load_dotenv()  # Load environment variables from .env file

secret_key = os.getenv("EMAIL_JWT_SECRET_KEY")
algorithm = os.getenv("EMAIL_JWT_ALGORITHM")


class SendEmailHandler:
    """Handler for sending email."""

    @staticmethod
    def send_mail(request, detail):
        """Send email to user."""
        receiver_parsing = request

        email = detail.email

        payload = {
            "email": email,
            "user_id": detail.id,
            "exp": datetime.utcnow() + timedelta(days=30),
        }
        token = jwt.encode(payload, secret_key, algorithm=algorithm)

        link = receiver_parsing.build_absolute_uri(
            "/api/email_otp/verify?token=",
        ) + token

        msg_html = render_to_string(
            "email_template.html",
            {"email": email, "link": link},
        )

        send_mail(
            "Secure File Sharing verify mail",
            message="",
            from_email=None,
            recipient_list=[email],
            fail_silently=False,
            html_message=msg_html,
        )

        return True


class VerifyEmailHandler(APIView):
    """Handler for verifying email."""

    def get(self, request) -> Response:
        try:
            parsing = request
            token = parsing.GET.get("token")

            payload = jwt.decode(token, secret_key, algorithms=[algorithm])

            queryset1 = EmailOTP.objects.get(
                id=payload.get("user_id"),
                email=payload.get("email"),
            )

            queryset1.date_verify = datetime.now()
            queryset1.save()

            return render(request, "success_template.html")
        except Exception:  # pylint: disable=broad-exception-caught
            return render(request, "404_page.html")

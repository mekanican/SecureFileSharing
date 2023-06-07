from django.urls import path

from .views import VerifyEmailHandler

urlpatterns = [
    path("verify", VerifyEmailHandler.as_view(), name="email-verify"),
]

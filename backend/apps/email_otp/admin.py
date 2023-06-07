# pylint: disable=C0411
from apps.email_otp.models import EmailOTP
from django.contrib import admin

admin.site.register(EmailOTP)

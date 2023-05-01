# pylint: disable=C0411
from apps.email_otp.models import EmailOTP
from django.contrib import admin

# Register your models here.
admin.register(EmailOTP)

from apps.email_otp.models import EmailOTP
from rest_framework import serializers


class EmailOTPSerializer(serializers.ModelSerializer):
    """Serializer for EmailOTP model."""
    class Meta:
        model = EmailOTP
        fields = ("id", "email", "date_verify")

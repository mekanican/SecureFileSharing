from rest_framework import serializers
from apps.email_otp.models import Email_otp

class email_otpSerializer(serializers.ModelSerializer ):
    class Meta:
        model =Email_otp
        fields=('id','email','date_send','date_verify'
                )

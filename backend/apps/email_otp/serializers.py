from rest_framework import serializers
from apps.email_otp.models import EmailOTP

class email_otpSerializer(serializers.ModelSerializer ):
    class Meta:
        model =EmailOTP
        fields=('id','email','date_send','date_verify'
                )

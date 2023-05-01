# from django.shortcuts import render

# # Create your views here.
import os
from django.http.response import JsonResponse
from rest_framework.parsers import JSONParser 
from rest_framework import status
from rest_framework.views import APIView
from apps.email_otp.models import EmailOTP
from apps.email_otp.serializers import email_otpSerializer
from django.core.mail import send_mail
from rest_framework.decorators import api_view
from django.template.loader import render_to_string
from pathlib import Path
import jwt
from datetime import datetime, timedelta
from rest_framework.response import Response
from .models import EmailOTP
from django.shortcuts import render

secret_key = 'mysecretkey'
algorithm='HS256'
class SendEmailHandler:
   
    def  SendMail(request,detail):
     
        receiverParsing=request;
        print(receiverParsing);
        email=detail.email
        payload = {
            'email':email,
            'user_id':detail.id,
            'exp': datetime.utcnow() + timedelta(days=30),
        }
        token = jwt.encode(payload, secret_key, algorithm=algorithm);

        link=receiverParsing.build_absolute_uri('/api/email_otp/verify?token=')+token;
        msg_html = render_to_string('email_template.html', {'email': email,'link':link})
    
        send_mail(
            "Secure File Sharing verify mail",
            message="",
            from_email=None,
            recipient_list=[email],
            fail_silently=False,
            html_message=msg_html,
        )
        return True;
SendEmailHandler.SendMail = staticmethod(SendEmailHandler.SendMail)

class VerifyEmailHandler(APIView):

    def get(self,request) -> Response:
        try:
            parsing=request
            token = parsing.GET.get("token");
            
            payload= jwt.decode(token, secret_key,algorithms=[algorithm])
            q1=EmailOTP.objects.get(id=payload.get('user_id'),email=payload.get('email'));
           # q2=q1.exclude(date_verify__gte=datetime.date.today());
            #q1.date_verify.set(datetime.date.today());
            print(q1.date_verify);
            q1.date_verify=datetime.now();
            q1.save();
            print(payload)
            return  render(request, 'success_template.html');
        except Exception:
          
            return render(request, '404_page.html')

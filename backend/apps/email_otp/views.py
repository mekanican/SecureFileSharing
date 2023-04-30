# from django.shortcuts import render

# # Create your views here.
import os
from django.http.response import JsonResponse
from rest_framework.parsers import JSONParser 
from rest_framework import status

from apps.email_otp.models import Email_otp
from apps.email_otp.serializers import email_otpSerializer
from django.core.mail import send_mail
from rest_framework.decorators import api_view
from django.template.loader import render_to_string
from pathlib import Path



@api_view(['GET', 'POST'])
def test(request):
    print(JSONParser().parse(request));
    return JsonResponse({'message': 'test'}, status=status.HTTP_200_OK) 
 
@api_view(['POST'])
def sendEmail(request):
    receiverParsing=JSONParser().parse(request);
    link ="";
    email=receiverParsing.get("email");
    msg_html = render_to_string('email_template.html', {'email': email,'link':link})
    print(email);
  
    send_mail(
        "Secure File Sharing verify mail",
        message="",
        from_email=None,
        recipient_list=[email],
        fail_silently=False,
        html_message=msg_html,
    )
    print("sent");
    return JsonResponse({'message': 'suceed'}, status=status.HTTP_200_OK) 

@api_view(['GET'])
def verifyAccount(request):

    return JsonResponse({'message': 'suceed'}, status=status.HTTP_200_OK) 

     # GET / PUT / DELETE tutorial
    
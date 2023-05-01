# from django.shortcuts import render
from django.urls import path
from apps.email_otp import views
from .views import SendEmailHandler,VerifyEmailHandler
urlpatterns= [
   

     path('verify',VerifyEmailHandler.as_view()),
] 
# Create your views here.

# from django.shortcuts import render
from django.urls import path
from apps.email_otp import views

urlpatterns= [
     path('test', views.test),
     path('sendMail', views.sendEmail),

] 
# Create your views here.

# from django.shortcuts import render
from django.urls import path
from apps.email_otp import views

urlpatterns= [
     path('test', views.test),

] 
# Create your views here.

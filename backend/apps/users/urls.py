# from django.shortcuts import render
from django.urls import path
from . import views

urlpatterns= [
     path('test', views.test),

] 
# Create your views here.

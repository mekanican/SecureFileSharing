"""Docstring."""
from django.urls import path,include
from .views import UploadFileHandler #,RemoveFileHandler

urlpatterns: list = [
 path('upload',UploadFileHandler.as_view(),name="uploadFile"),
# path('remove',RemoveFileHandler.as_view(),name="removeFile"),
 
]  


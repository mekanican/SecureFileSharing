"""Docstring."""
from django.urls import include, path

from .views import ChatHandler, FriendHandler, UploadFileHandler

urlpatterns: list = [
    path('upload/', UploadFileHandler.as_view(),name="uploadFile"),
    path('chat/', ChatHandler.as_view(), name="chatRoom"),
    path('friend/', FriendHandler.as_view(), name="getFriend")
]

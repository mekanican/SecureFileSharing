from django.urls import path

from .views import ChatHandler, FriendHandler, UploadFileHandler

urlpatterns = [
    path("upload/", UploadFileHandler.as_view(), name="upload-file"),
    path("chat/", ChatHandler.as_view(), name="chat-room"),
    path("friend/", FriendHandler.as_view(), name="get-friend"),
]

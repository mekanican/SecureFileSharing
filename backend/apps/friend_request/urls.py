from django.urls import path

from .views import AddFriendCode, UserFriendCode, UserGenerateFriendCode

urlpatterns = [
    path(
        "generate/",
        UserGenerateFriendCode.as_view(),
        name="generate_friend_code",
    ),
    path("get/", UserFriendCode.as_view(), name="get_friend_code"),
    path("add/", AddFriendCode.as_view(), name="get_friend_code"),
]

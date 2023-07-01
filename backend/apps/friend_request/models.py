
from django.db import models


class FriendRequest(models.Model):
    """Model for FriendRequest."""

    id = models.BigAutoField(primary_key=True, unique=True)
    friend_code_token = models.CharField(max_length=254)
    friend_code = models.CharField(max_length=254)
    status = models.CharField(max_length=20)


class FriendList(models.Model):
    """Model for FriendList."""

    id = models.BigAutoField(primary_key=True, unique=True)
    user_idA = models.CharField(max_length=254)
    user_idB = models.CharField(max_length=254)
    status = models.CharField(max_length=20)

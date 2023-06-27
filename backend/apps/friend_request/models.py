
from django.db import models


class FriendRequest(models.Model):
    """Model for FriendRequest."""

    # null = False is the default, so we don't need to specify it.
    id = models.BigAutoField(primary_key=True, unique=True)
    friend_code_token= models.CharField(max_length=254)
    friend_code = models.CharField(max_length=254)
    status = models.CharField(max_length=20)

class FriendList(models.Model):
    """Model for FriendList."""

    # null = False is the default, so we don't need to specify it.
    id = models.BigAutoField(primary_key=True, unique=True)
    user_idA= models.CharField(max_length=254)
    user_idB = models.CharField(max_length=254)
    status = models.CharField(max_length=20)

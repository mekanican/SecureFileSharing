from django.db import models

from ...users.models import User


class FileSharing(models.Model):
    # username = models.CharField(max_length=50,)
    from_ = models.ForeignKey(User, on_delete=models.CASCADE)
    to_ = models.ForeignKey(User, on_delete=models.CASCADE)
    # file_name = models.CharField(max_length=255, blank=True)
    url= models.CharField(max_length=1000,blank=True)
    uploaded_at = models.DateTimeField(auto_now_add=True)
    # bucket_name= models.CharField(max_length=255,blank=True)

    
from django.db import models

class FileSharing(models.Model):
   
    file_name = models.CharField(max_length=255, blank=True)
    url= models.URLField(max_length=1000,blank=True)
    uploaded_at = models.DateTimeField(auto_now_add=True)
    bucket_name= models.CharField(max_length=255,blank=True)

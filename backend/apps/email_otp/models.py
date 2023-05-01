
from django.db import models

#auth_user board
class EmailOTP(models.Model):
    id= models.BigAutoField(primary_key=True,unique=True,null=False)
    email=models.CharField(max_length=254,null=False)
    date_verify=models.DateTimeField(blank=True,null=True)
  

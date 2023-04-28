from django.db import models

#auth_user board
class Auth_user(models.Model):
    id= models.AutoField(primary_key=True,unique=True,null=False)
    password=models.CharField(max_length=128,null=False)
    last_login= models.DateTimeField(max_length=6,blank=True)
    is_superuser= models.SmallIntegerField(null=False)
    username=models.CharField(max_length=150,null=False)
    first_name=models.CharField(max_length=150,null=False)
    email=models.CharField(max_length=254,null=False)
    is_staff= models.SmallIntegerField(null=False)
    is_active=models.SmallIntegerField(null=False)
    date_joined = models.DateTimeField(max_length=6,null=False)

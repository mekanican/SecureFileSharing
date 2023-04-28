from rest_framework import serializers
from users.models import Auth_user

class auth_userSerializer(serializers.ModelSerializer ):
    class Meta:
        model =Auth_user
        fields=('id',
                'password',
                'last_login',
                'is_superuser',
                'username',
                'first_name',
                'last_name',
                'email',
                'is_staff',
                'is_active',
                'date_joined'
                )

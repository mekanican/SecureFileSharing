from rest_framework import serializers;
from ..models.filesharing import FileSharing
from ...users.models import User
from drf_extra_fields.fields import Base64FileField

class FileSharingSerializer(serializers.ModelSerializer):
 
    class Meta:
        model = FileSharing
        fields = ["id", "username", "filename","myfile"]

    def validate_username( value):
        """Validate password.

        Validate the password against the password validation policy.

        """
        return len(User.objects.filter(username=value))
       

from rest_framework import serializers

from ...users.models import User
from ..models.filesharing import FileSharing


class FileSharingSerializer(serializers.ModelSerializer):
    class Meta:
        model = FileSharing
        fields = ["from_user", "to_user", "url", "uploaded_at"]

    def validate_username(value):
        """Validate password.

        Validate the password against the password validation policy.

        """
        return len(User.objects.filter(username=value))
from rest_framework import serializers

from ..models import FileSharing


class FileSharingSerializer(serializers.ModelSerializer):
    """Serializer for file sharing."""
    class Meta:
        model = FileSharing
        fields = (
            "from_user",
            "to_user",
            "url",
            "uploaded_at",
        )

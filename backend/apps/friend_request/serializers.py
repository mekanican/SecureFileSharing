from apps.friend_request.models import FriendRequest
from rest_framework import serializers


class FriendRequestSerializer(serializers.ModelSerializer):
    """Serializer for FriendRequest model."""
    class Meta:
        model = FriendRequest
        fields = (
            "id",
            "from_id",
            "friend_code",
            "status",
            "friend_code_token",
        )

# pylint: disable=too-few-public-methods
from django.contrib.auth import get_user_model, password_validation
from rest_framework import serializers

User = get_user_model()


class UserSerializer(serializers.ModelSerializer):
    """Serializer for User model.

    Used to serialize and deserialize the user data to and from JSON format.
    """

    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ["id", "username", "email", "password"]
        read_only_fields = ["id"]

    def validate_password(self, value):
        """Validate password.

        Validate the password against the password validation policy.

        """
        password_validation.validate_password(value)
        return value

    def validate_email(self, value):
        """Validate email.

        Ensure that there is no user with the same email address.

        """
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError(
                "User with this email already exists.",
            )
        return value

    def create(self, validated_data):
        user = User.objects.create(
            username=validated_data["username"],
            email=validated_data["email"],
        )

        user.set_password(validated_data["password"])
        user.save()

        return user

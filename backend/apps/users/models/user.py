# pylint: disable=too-few-public-methods
from django.contrib.auth import password_validation
from django.contrib.auth.models import (
    AbstractBaseUser,
    Group,
    Permission,
    PermissionsMixin,
    UserManager,
)
from django.db import models
from django.utils.translation import gettext_lazy as _


class CustomUserManager(UserManager):
    """The adjusted version of UserManager to work with username."""
    # pylint: disable=arguments-differ
    def _create_user(self, username, email, password, **extra_fields):
        """Create and save a user.

        Need to provide the username, email and password.

        """
        if not email:
            raise ValueError("The given email must be set")
        email = self.normalize_email(email)
        user = self.model(email=email, username=username, **extra_fields)
        if password:
            password_validation.validate_password(password)
            user.set_password(password)
        user.save(using=self._db)
        return user

    # pylint: disable=arguments-differ
    # pylint: disable=signature-differs
    def create_superuser(self, username, email, password=None, **extra_fields):
        """Create superuser instance (used by `createsuperuser` cmd)."""
        extra_fields.setdefault("is_staff", True)
        extra_fields.setdefault("is_superuser", True)

        if extra_fields.get("is_staff") is not True:
            raise ValueError("Superuser must have is_staff=True.")
        if extra_fields.get("is_superuser") is not True:
            raise ValueError("Superuser must have is_superuser=True.")

        return self._create_user(username, email, password, **extra_fields)


class User(AbstractBaseUser, PermissionsMixin):
    """Docstring."""

    username = models.CharField(
        max_length=50,
        unique=True,
        verbose_name=_("Username"),
    )

    real_name = models.CharField(
        max_length=50,
        blank=True,
        null=True,
        verbose_name=_("Real name"),
    )

    email = models.EmailField(
        verbose_name=_("Email address"),
        max_length=254,  # to be compliant with RFCs 3696 and 5321
        unique=True,
    )

    friends = models.ManyToManyField(
        verbose_name=_("Friends"),
        to="self",
    )

    is_online = models.BooleanField(
        verbose_name=_("Is online"),
        default=True,
    )

    is_staff = models.BooleanField(
        verbose_name=_("Staff status"),
        default=False,
        help_text=_(
            "Designates whether the user can log into this admin site.",
        ),
    )

    groups = models.ManyToManyField(
        verbose_name=_("groups"),
        related_name="custom_users",
        blank=True,
        help_text=_("The groups this user belongs to."),
        related_query_name="custom_user",
        to=Group,
    )

    user_permissions = models.ManyToManyField(
        verbose_name=_("user permissions"),
        blank=True,
        help_text=_("Specific permissions for this user."),
        related_name="users_user_permissions",
        related_query_name="users_user_permission",
        to=Permission,
    )

    EMAIL_FIELD = "email"
    USERNAME_FIELD = "username"
    REQUIRED_FIELDS = [EMAIL_FIELD, USERNAME_FIELD]

    objects = CustomUserManager()

    class Meta:
        verbose_name = _("User")
        verbose_name_plural = _("Users")

    def __str__(self):
        # pylint: disable=invalid-str-returned
        return self.username

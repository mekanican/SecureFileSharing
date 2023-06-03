# pylint: disable=wrong-import-order

from apps.file_sharing.models import FileSharing
from django.contrib import admin

admin.site.register(FileSharing)

from django.contrib import admin

from .models import RSAPrivateKey, RSAPublicKey

admin.site.register(RSAPublicKey)

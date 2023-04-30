from django.urls import path

from .views import RSAKeyGenerateView

urlpatterns = [
    path("generate/", RSAKeyGenerateView.as_view(), name="generate-keys"),
]

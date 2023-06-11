from django.urls import path

from .views import RSAKeyGenerateView, RSAPublicKeyGetAPIView

urlpatterns = [
    path("generate", RSAKeyGenerateView.as_view(), name="generate-keys"),
    path("get", RSAPublicKeyGetAPIView.as_view(), name="get-public-key"),
]

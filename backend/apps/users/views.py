
from django.http.response import JsonResponse
from rest_framework.parsers import JSONParser 
from rest_framework import status
 

from rest_framework.decorators import api_view



@api_view(['GET', 'POST'])
def test(request):
    print(JSONParser().parse(request));
    return JsonResponse({'message': 'test'}, status=status.HTTP_200_OK) 
 
    # GET / PUT / DELETE tutorial
    
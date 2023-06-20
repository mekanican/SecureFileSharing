import os
import jwt
from dotenv import load_dotenv
from rest_framework.parsers import JSONParser
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import status
from django.contrib.auth import get_user_model
from rest_framework.authtoken.models import Token
from .models import FriendRequest,FriendList
import string
import random

User = get_user_model()
load_dotenv()  # Load environment variables from .env file

secret_key = os.getenv("FRIEND_JWT_SECRET_KEY")
algorithm = os.getenv("FRIEND_JWT_ALGORITHM")
length=os.getenv("FRIEND_CODE_LENGTH")

def generate_friend_code(length=length ):
    random_string = ''.join(random.choices(string.ascii_lowercase + string.digits, k=int(length)))
    return random_string

class UserGenerateFriendCode(APIView):
    """API generate friend code."""

    def post(self, request) -> Response:
        try:
            clone_request = JSONParser().parse(request)
            token = clone_request.get("token")
            user = Token.objects.get(key=token).user
            queryset = User.objects.get(id=user.id)
        except Token.DoesNotExist:
            return Response({"messages":"User not found"}, status=status.HTTP_400_BAD_REQUEST)
        except User.DoesNotExist:
            return Response({"messages":"User not found"}, status=status.HTTP_400_BAD_REQUEST)
        
       
        payload = {"request_id":queryset.username}
        friend_code_token = jwt.encode(payload, secret_key, algorithm=algorithm)
        
        try:
            check_exist = FriendRequest.objects.get(friend_code_token=friend_code_token)
        except FriendRequest.DoesNotExist:
            check_exist = None

        friend_code =generate_friend_code()
        while FriendRequest.objects.filter(friend_code=friend_code, status="active").exists():
            friend_code = generate_friend_code()
        
        if check_exist is not None:
            check_exist.friend_code_token = friend_code_token
            check_exist.friend_code = friend_code
            check_exist.status = "active"
            check_exist.save()
        else:
            check_exist = FriendRequest.objects.create(friend_code=friend_code, friend_code_token=friend_code_token, status="active")
        
        return Response({"friend_code":friend_code}, status=status.HTTP_200_OK)
    
class UserFriendCode(APIView):
    """API get friend code."""

    def post(self, request) -> Response:
        try:
            clone_request = JSONParser().parse(request)
            token = clone_request.get("token")
            user = Token.objects.get(key=token).user
            queryset = User.objects.get(id=user.id)
        except Token.DoesNotExist:
            return Response({"messages":"User not found"}, status=status.HTTP_400_BAD_REQUEST)
        except User.DoesNotExist:
            return Response({"messages":"User not found"}, status=status.HTTP_400_BAD_REQUEST)
        
        payload = {"request_id": queryset.username}
        friend_code_token = jwt.encode(payload, secret_key, algorithm=algorithm)
        
        try:
            friend = FriendRequest.objects.get(friend_code_token=friend_code_token)
        except FriendRequest.DoesNotExist:
            friend_code = generate_friend_code()
            while FriendRequest.objects.filter(friend_code=friend_code, status="active").exists():
                friend_code =generate_friend_code()
            friend = FriendRequest.objects.create(friend_code=friend_code, friend_code_token=friend_code_token, status="active")
        
        return Response({"friend_code": friend.friend_code}, status=status.HTTP_200_OK)

class AddFriendCode(APIView):
    """API query friend code."""

    def post(self, request) -> Response:
        try:
            clone_request = JSONParser().parse(request)
            token = clone_request.get("token")
            friend_code = clone_request.get("friend_code")
            user = Token.objects.get(key=token).user
            user_id = User.objects.get(id=user.id)
        except Token.DoesNotExist:
            return Response({"messages":"User not found"}, status=status.HTTP_400_BAD_REQUEST)
        except User.DoesNotExist:
            return Response({"messages":"User not found"}, status=status.HTTP_400_BAD_REQUEST)
        
    
        payload = {"request_id": user_id.username}
        friend_code_token = jwt.encode(payload, secret_key, algorithm=algorithm)
        
        try:
            friend = FriendRequest.objects.get(friend_code=friend_code)
        except FriendRequest.DoesNotExist:
            return Response({"messages":"Friend code invalid"}, status=status.HTTP_400_BAD_REQUEST)
        
        if friend.friend_code_token == friend_code_token:
            return Response({"messages":"Cannot add yourself"}, status=status.HTTP_400_BAD_REQUEST)
        payload = jwt.decode(friend.friend_code_token, secret_key, algorithms=[algorithm])
        friend_username= payload['request_id']
        friend_id= User.objects.get(username=friend_username).id

        if not FriendList.objects.filter(user_idA=user.id,user_idB=friend_id).exists() and not FriendList.objects.filter(user_idA=friend_id,user_idB=user.id).exists():
            FriendList.objects.create(user_idA=user.id,user_idB=friend_id,status="active")
            return Response({"messages": "success"}, status=status.HTTP_200_OK)
        else:
            return Response({"messages":"Friend exist"}, status=status.HTTP_400_BAD_REQUEST)

            

     

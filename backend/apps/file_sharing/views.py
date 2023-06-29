# pylint: disable=no-member, broad-exception-caught, wrong-import-order

import base64
import os
from datetime import datetime
from io import BytesIO

import requests
from apps.file_sharing.minio_handler import MinioHandler
from django.contrib.auth import get_user_model
from django.db import connection
from django.shortcuts import render
from dotenv import load_dotenv
from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.parsers import JSONParser
from rest_framework.response import Response
from rest_framework.views import APIView

from .models.filesharing import FileSharing
from .serializers import FileSharingSerializer
from apps.friend_request.models import FriendList
from django.db.models import Q

User = get_user_model()

MINIO_HANDLER = MinioHandler.get_instance()

load_dotenv()  # Load environment variables from .env file

# CHAT_SERVICE_HOST = os.getenv("CHAT_SERVICE_HOST")
# CHAT_SERVICE_PORT = os.getenv("CHAT_SERVICE_PORT")
CHAT_SERVICE_URL = os.getenv("CHAT_SERVICE_URL")


def notifier(user1: int, user2: int) -> None:
    """Notify both user 1 and 2 to reload their chat."""
    try:
        requests.get(CHAT_SERVICE_URL + "/" + str(user1), timeout=8)
    except Exception as e:
        print(CHAT_SERVICE_URL + "/" + str(user1))
        print(e)
    try:
        requests.get(CHAT_SERVICE_URL + "/" + str(user2), timeout=8)
    except Exception as e:
        print(CHAT_SERVICE_URL + "/" + str(user2))
        print(e)


def is_base64(string_bytes) -> bool:
    """Check if string is base64."""
    try:
        if isinstance(string_bytes, str):
            # If there's any unicode here, an exception will be thrown
            # and the function will return false
            sb_bytes = bytes(string_bytes, "ascii")
        elif isinstance(string_bytes, bytes):
            sb_bytes = string_bytes
        else:
            raise ValueError("Argument must be string or bytes")
        return base64.b64encode(base64.b64decode(sb_bytes)) == sb_bytes
    except Exception:
        return False


class UploadFileHandler(APIView):
    """Handler for uploading file."""

    serializer_class = FileSharingSerializer

    def get(self, request):
        clone_request = request

        files = FileSharing.objects.all()

        return render(
            request,
            "upload_test.html",
            {
                "files": files,
                "urlRemove": clone_request.build_absolute_uri(
                    "/api/fileSharing/remove",
                ),
            },
        )

    def post(self, request):
        clone_request = JSONParser().parse(request)

        # Put file to Minio
        myfile = clone_request.get("myfile")
        filename = clone_request.get("filename")
        token = clone_request.get("token")
        to_id = clone_request.get("to")
        time_to_live = clone_request.get("ttl")

        user = Token.objects.get(key=token).user

        try:
            if not is_base64(myfile):
                return Response(
                    {"messages": "File content must be base64"},
                    status=status.HTTP_400_BAD_REQUEST,
                )
            file_data = base64.b64decode(myfile)

            # Check for time_to_live
            # Maximum 1 year expiration
            if (
                not isinstance(time_to_live, int) or
                    not (1 <= time_to_live <= 365)
            ):
                return Response(
                    {"messages": "Invalid time to live"},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            # Check for compatible to_id:
            if not User.objects.filter(id=to_id).exists():
                return Response(
                    {"messages": "ID not exist"},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            # There's at least 1 message between this & that
            # (Hello message when add friend)
            if (
                not FileSharing.objects.filter(
                    from_user=user.id,
                    to_user=to_id,
                ) and
                    not FileSharing.objects.filter(
                        from_user=to_id,
                        to_user=user.id,
                )
            ):
                return Response(
                    {"messages": "Receiver id not recognized"},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            file_store_in_minio = MINIO_HANDLER.put_object(
                file_data=BytesIO(file_data),
                file_name=filename,
                content_type="application/octet-stream",
                ttl=time_to_live,
            )

            file = FileSharing()
            file.from_user = user
            file.to_user = User.objects.get(id=to_id)
            file.file_name = filename
            file.url = file_store_in_minio["url"]
            file.uploaded_at = datetime.now()
            file.save()

            # Now notify both of them for reloading
            try:
                notifier(user.id, to_id)
            except Exception:
                pass

            return Response(
                {"messages": "success", "url": file.url},
                status=status.HTTP_201_CREATED,
            )
        except Exception as err:
            return Response(
                {"messages": str(err), "url": ""},
                status=status.HTTP_400_BAD_REQUEST,
            )


class ChatHandler(APIView):
    """Handler for chat."""

    def post(self, request):
        clone_request = JSONParser().parse(request)

        token = clone_request.get("token")
        to_id = clone_request.get("to_id")
        user = Token.objects.get(key=token).user

        # Check for compatible to_id:
        if not User.objects.filter(id=to_id).exists():
            return Response(
                {"messages": "ID not exist"},
                status=status.HTTP_400_BAD_REQUEST,
            )

        # There's at least 1 message between this & that
        # (Hello message when add friend)
        if (
            not FileSharing.objects.filter(
                from_user=user.id,
                to_user=to_id,
            ) and
                not FileSharing.objects.filter(
                    from_user=to_id,
                    to_user=user.id,
            )
        ):
            return Response(
                {"messages": "Receiver id not recognized"},
                status=status.HTTP_400_BAD_REQUEST,
            )

        queryset = FileSharing.objects.filter(
            from_user=user.id,
            to_user=to_id,
        ).union(
            FileSharing.objects.filter(
                from_user=to_id,
                to_user=user.id,
            ),
        ).order_by("-uploaded_at").values()

        result = list(queryset)

        return Response(
            result,
            status=status.HTTP_200_OK,
        )


class FriendHandler(APIView):
    """Handler for friend."""

    def post(self, request):
        clone_request = JSONParser().parse(request)
        token = clone_request.get("token")
        user = Token.objects.get(key=token).user

        result = []

        with connection.cursor() as cursor:
            cursor.execute("""
            SELECT tmp_table.*, auth_user.username
            FROM
                (
                    SELECT DISTINCT
                        MAX(file_sharing_filesharing.uploaded_at),
                        file_sharing_filesharing.to_user_id AS 'friend_id'
                    FROM
                        file_sharing_filesharing
                    WHERE
                        file_sharing_filesharing.from_user_id = %(id)s
                    GROUP BY
                        friend_id
                UNION
                    SELECT DISTINCT
                        MAX(file_sharing_filesharing.uploaded_at),
                        file_sharing_filesharing.from_user_id AS 'friend_id'
                    FROM
                        file_sharing_filesharing
                    WHERE
                        file_sharing_filesharing.to_user_id = %(id)s
                    GROUP BY
                        friend_id
                ) as tmp_table
            INNER JOIN
                auth_user ON auth_user.id = tmp_table.friend_id
            """, {"id": user.id})

            # For each friend, if occur more than once in the query
            # (means that there's a message from both side)
            # then we only take the latest one
            query_result = {}
            for i in cursor.fetchall():
                if i[1] not in query_result:
                    query_result[i[1]] = i

            for i in query_result.values():
                result.append({
                    "friend_id": i[1],
                    "uploaded_at": i[0].strftime("%Y-%m-%dT%H:%M:%S"),
                    "username": i[2],
                })

        # add friend that haven't chat
        if FriendList.objects.filter(Q(user_idA=user.id) | Q(user_idB=user.id)).exists():
            friend_list= FriendList.objects.filter(Q(user_idA=user.id) | Q(user_idB=user.id))
            for rows in friend_list.values():        
                userA= User.objects.get(id=rows['user_idA'])
                userB= User.objects.get(id=rows['user_idB'])
                temp_user= userA if(userA.id!=user.id) else userB
                if not any(item["friend_id"] == temp_user.id for item in result):
                   result.append({
                    "friend_id": temp_user.id,
                    "uploaded_at": "",
                    "username": temp_user.get_username(),
                    })
                        
        return Response(
            result,
            status=status.HTTP_200_OK,
        )

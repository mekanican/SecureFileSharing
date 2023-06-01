import base64
import json
from datetime import datetime
from io import BytesIO

import requests
from apps.file_sharing.minio_handler import MinioHandler
from django.contrib.auth import get_user_model
from django.core.files.storage import FileSystemStorage
from django.db import connection
from django.db.models import F
from django.http import HttpResponse, HttpResponseRedirect
from django.shortcuts import render
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt, csrf_protect
from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.parsers import JSONParser
from rest_framework.response import Response
from rest_framework.views import APIView

User = get_user_model()

from .models.filesharing import FileSharing
from .serializers import FileSharingSerializer

minio_handler = MinioHandler.get_instance()

CHAT_SERVICE_PORT = "23432"  # TODO: Export to env


def isBase64(sb):
    try:
        if isinstance(sb, str):
            # If there's any unicode here, an exception will be thrown and the function will return false
            sb_bytes = bytes(sb, "ascii")
        elif isinstance(sb, bytes):
            sb_bytes = sb
        else:
            raise ValueError("Argument must be string or bytes")
        return base64.b64encode(base64.b64decode(sb_bytes)) == sb_bytes
    except Exception:
        return False


class UploadFileHandler(APIView):
    serializer_class = FileSharingSerializer

    def get(self, request):
        cloneRequest = request
        # breakpoint()
        files = FileSharing.objects.all()
        print(files)
        return render(
            request,
            "upload_test.html",
            {
                "files": files,
                "urlRemove": cloneRequest.build_absolute_uri("/api/fileSharing/remove"),
            },
        )

    def post(self, request):
        cloneRequest = JSONParser().parse(request)

        # Put file to Minio

        myfile = cloneRequest.get("myfile")
        filename = cloneRequest.get("filename")
        token = cloneRequest.get("token")
        # username=cloneRequest.get("username")
        to_id = cloneRequest.get("to")
        time_to_live = cloneRequest.get("ttl")

        user = Token.objects.get(key=token).user

        try:
            if not isBase64(myfile):
                return Response(
                    {"messages": "File content must be base64"},
                    status=status.HTTP_400_BAD_REQUEST,
                )
            file_data = base64.b64decode(myfile)

            # Check for time_to_live
            # Maximum 1 year expiration
            if not isinstance(time_to_live, int) or not (1 <= time_to_live <= 365):
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
            # There's at least 1 message between this & that (Hello message when add friend)
            if not FileSharing.objects.filter(from_user=user.id, to_user=to_id)\
               and not FileSharing.objects.filter(from_user=to_id, to_user=user.id):
                return Response(
                    {"messages": "Receiver id not recognized"},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            fileStoreInMinio = minio_handler.put_object(
                file_data=BytesIO(file_data),
                file_name=filename,
                content_type="application/octet-stream",
                ttl=time_to_live,
            )
            file = FileSharing()
            file.from_user = user
            file.to_user = User.objects.get(id=to_id)
            file.file_name = filename  # fileStoreInMinio["file_name"]
            file.url = fileStoreInMinio["url"]
            file.uploaded_at = datetime.now()
            file.save()
            # Now notify both of them for reloading
            try:
                requests.get("localhost:" + CHAT_SERVICE_PORT + "/" + str(user.id), timeout=5)
                requests.get("localhost:" + CHAT_SERVICE_PORT + "/" + str(to_id), timeout=5)
            except Exception as e:
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


# No need this since time to live is enough
# class RemoveFileHandler(APIView):
#     def post(self, request):
#         cloneRequest = request
#         jsonDelete = JSONParser().parse(cloneRequest)
#         file_name = jsonDelete.get("filename")

#         try:
#             q1 = FileSharing.objects.get(file_name=file_name)
#             if q1 and minio_handler.check_file_name_exists(
#                 bucket_name=minio_handler.make_bucket(), file_name=file_name
#             ):
#                 print(file_name)

#                 if minio_handler.remove_object(q1.bucket_name, q1.file_name):
#                     q1.delete()
#                     return Response(
#                         {"messages": "success"},
#                         status=status.HTTP_201_CREATED,
#                     )
#         except:
#             return Response(
#                 {"messages": "file not exist"},
#                 status=status.HTTP_400_BAD_REQUEST,
#             )
#         # return HttpResponseRedirect(redirect_to=cloneRequest.build_absolute_uri('/api/fileSharing/upload')) #uncomment for testing


class ChatHandler(APIView):
    def post(self, request):
        cloneRequest = JSONParser().parse(request)
        token = cloneRequest.get("token")
        to_id = cloneRequest.get("to_id")
        user = Token.objects.get(key=token).user
        # Check for compatible to_id:
        if not User.objects.filter(id=to_id).exists():
            return Response(
                {"messages": "ID not exist"},
                status=status.HTTP_400_BAD_REQUEST,
            )
        # There's at least 1 message between this & that (Hello message when add friend)
        if not FileSharing.objects.filter(from_user=user.id, to_user=to_id)\
           and not FileSharing.objects.filter(from_user=to_id, to_user=user.id):
            return Response(
                {"messages": "Receiver id not recognized"},
                status=status.HTTP_400_BAD_REQUEST,
            )

        qs = FileSharing.objects.filter(from_user=user.id, to_user=to_id)\
            .union(FileSharing.objects.filter(from_user=to_id, to_user=user.id))\
            .order_by('uploaded_at')\
            .values()

        result = [entry for entry in qs]

        return Response(
            result,
            status=status.HTTP_200_OK
        )


class FriendHandler(APIView):
    def post(self, request):
        cloneRequest = JSONParser().parse(request)
        token = cloneRequest.get("token")
        user = Token.objects.get(key=token).user

        result = []

        with connection.cursor() as cursor:
            cursor.execute("""
            SELECT tmp_table.*, auth_user.username
            FROM
                (
                    SELECT
                        MAX(file_sharing_filesharing.uploaded_at), 
                        file_sharing_filesharing.to_user_id AS 'friend_id'
                    FROM 
                        file_sharing_filesharing 
                    WHERE 
                        file_sharing_filesharing.from_user_id = %(id)s
                    GROUP BY
                        friend_id
                UNION 
                    SELECT 
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
            for i in cursor.fetchall():
                result.append({
                    "friend_id":i[1],
                    "uploaded_at":i[0].strftime("%Y-%m-%dT%H:%M:%S"),
                    "username":i[2]
                })

        return Response(
            result,
            status=status.HTTP_200_OK
        )


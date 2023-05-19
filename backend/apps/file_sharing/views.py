import base64
import json
from datetime import datetime
from io import BytesIO

from apps.file_sharing.minio_handler import MinioHandler
from django.core.files.storage import FileSystemStorage
from django.http import HttpResponse, HttpResponseRedirect
from django.shortcuts import render
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt, csrf_protect
from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.parsers import JSONParser
from rest_framework.response import Response
from rest_framework.views import APIView

from ..users.models import User
from .models.filesharing import FileSharing
from .serializers import FileSharingSerializer

minio_handler = MinioHandler.get_instance()


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

        # if(FileSharingSerializer.validate_username(username)==0):
        #         return Response(
        #             {"messages":"username not available"},
        #             status=status.HTTP_400_BAD_REQUEST,
        #         )
        try:
            if isBase64(myfile) == False:
                return Response(
                    {"messages": "File content must be base64"},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            # No file has the same name since put_onject automatically add time stamp to name stored on server!
            # if minio_handler.check_file_name_exists(
            #     bucket_name=minio_handler.make_bucket(), file_name=filename
            # ):
            #     return Response(
            #         {"messages": "file name exist"},
            #         status=status.HTTP_400_BAD_REQUEST,
            #     )
            # else:
            file_data = base64.b64decode(myfile)

            # Check for time_to_live
            # Maximum 1 year expiration
            if not isinstance(time_to_live, int) or not (1 <= time_to_live <= 365):
                return Response(
                    {"messages": "Invalid time to live"},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            fileStoreInMinio = minio_handler.put_object(
                file_data=BytesIO(file_data),
                file_name=filename,
                content_type="application/octet-stream",
                ttl=time_to_live
            )
            file = FileSharing.objects.create()
            file.from_ = user.id
            
            # Check for compatible to_id:
            if not User.objects.filter(id=to_id).exists():
                return Response(
                    {"messages": "ID not exist"},
                    status=status.HTTP_400_BAD_REQUEST,
                )
            # TODO: Check for friends ? Make another table n-n User-User for friend specification
                
            file.to_ = to_id
            file.file_name = filename # fileStoreInMinio["file_name"]
            file.url = fileStoreInMinio["url"]
            # file.bucket_name = fileStoreInMinio["bucket_name"]
            file.uploaded_at = datetime.now()
            file.save()

            return Response(
                {"messages": "success", "url": file.url},
                status=status.HTTP_201_CREATED,
            )
        except Exception as err:
            return Response(
                {"messages": str(err), "url": ""},
                status=status.HTTP_400_BAD_REQUEST,
            )
            # return HttpResponseRedirect(redirect_to=cloneRequest.build_absolute_uri('/api/fileSharing/upload')) # uncomment for testing


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

from django.http import HttpResponse,HttpResponseRedirect
from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from django.views.decorators.csrf import csrf_exempt, csrf_protect
from django.utils.decorators import method_decorator
from .models.filesharing import FileSharing
from apps.file_sharing.minio_handler import MinioHandler
from django.core.files.storage import FileSystemStorage
from io import BytesIO
from datetime import datetime
from rest_framework import status
from .serializers import FileSharingSerializer 
from rest_framework.parsers import JSONParser 
import base64
import json

minio_handler= MinioHandler.get_instance();
def isBase64(sb):
    try:
            if isinstance(sb, str):
                    # If there's any unicode here, an exception will be thrown and the function will return false
                    sb_bytes = bytes(sb, 'ascii')
            elif isinstance(sb, bytes):
                    sb_bytes = sb
            else:
                    raise ValueError("Argument must be string or bytes")
            return base64.b64encode(base64.b64decode(sb_bytes)) == sb_bytes
    except Exception:
            return False

class UploadFileHandler(APIView):
    serializer_class = FileSharingSerializer
    def get(self,request):
        cloneRequest=request
        files = FileSharing.objects.all()
        print(files)
        return render(request, 'upload_test.html',{'files':files,'urlRemove':cloneRequest.build_absolute_uri('/api/fileSharing/remove')})

    def post(self,request):
        cloneRequest=JSONParser().parse( request)
     
        
       # Put file to Minio
   
        myfile = cloneRequest.get("myfile")
        filename=cloneRequest.get("filename")
        username=cloneRequest.get("username")
 
        # if(FileSharingSerializer.validate_username(username)==0):
        #         return Response(
        #             {"messages":"username not available"},
        #             status=status.HTTP_400_BAD_REQUEST,
        #         )
        try:
            if(isBase64(myfile)==False):
                    return Response(
                        {"messages":"File content must be base64"},
                        status=status.HTTP_400_BAD_REQUEST,
                    )
            
            if minio_handler.check_file_name_exists(bucket_name=minio_handler.make_bucket() , file_name=filename):
                return Response(
                        {"messages":"file name exist"},
                        status=status.HTTP_400_BAD_REQUEST,
                    )
            else:
                file_data=base64.b64decode(myfile)
         
                fileStoreInMinio = minio_handler.put_object(
                    file_data=BytesIO(file_data),
                    file_name=filename,
                    content_type="application/octet-stream",
                ) 
                file=  FileSharing.objects.create()
                file.username=username
                file.file_name=fileStoreInMinio["file_name"]
                file.url= fileStoreInMinio['url']
                file.bucket_name= fileStoreInMinio['bucket_name']
                file.uploaded_at=datetime.now()
                file.save();

                return Response(
                    {"messages":"success","url":file.url},
                    status=status.HTTP_201_CREATED,
                )
        except  Exception as err :

            return Response(
                {"messages":str(err),"url":""},
                status=status.HTTP_400_BAD_REQUEST,
            )
            #return HttpResponseRedirect(redirect_to=cloneRequest.build_absolute_uri('/api/fileSharing/upload')) # uncomment for testing

class RemoveFileHandler(APIView):
    def post(self,request):
        cloneRequest=request
        jsonDelete=JSONParser().parse( cloneRequest)
        file_name=jsonDelete.get('filename')

        try:
            q1=FileSharing.objects.get(file_name=file_name);
            if q1 and minio_handler.check_file_name_exists(bucket_name=minio_handler.make_bucket() , file_name= file_name):
                
                print(file_name)
            
                if minio_handler.remove_object(q1.bucket_name,q1.file_name):
                    q1.delete();
                    return Response(
                                {"messages":"success"},
                                status=status.HTTP_201_CREATED,
                            )
        except:
            return Response(
                        {"messages":"file not exist"},
                        status=status.HTTP_400_BAD_REQUEST,
                    )
        #return HttpResponseRedirect(redirect_to=cloneRequest.build_absolute_uri('/api/fileSharing/upload')) #uncomment for testing


from django.http import HttpResponse,HttpResponseRedirect
from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from django.views.decorators.csrf import csrf_exempt, csrf_protect
from django.utils.decorators import method_decorator
from ..file_sharing.models import FileSharing
from apps.file_sharing.minio_handler import MinioHandler
from django.core.files.storage import FileSystemStorage
from io import BytesIO
from datetime import datetime
from rest_framework import status

from rest_framework.parsers import JSONParser 

minio_handler= MinioHandler.get_instance();
class UploadFileHandler(APIView):
   
    def get(self,request):
        cloneRequest=request
        files = FileSharing.objects.all()
        print(files)
        return render(request, 'upload_test.html',{'files':files,'urlRemove':cloneRequest.build_absolute_uri('/api/fileSharing/remove')})

    def post(self,request):
        cloneRequest=request
       # Put file to Minio
   
        if cloneRequest.FILES:
         
            myfile = cloneRequest.FILES['myfile']
         
            
            if minio_handler.check_file_name_exists(bucket_name=minio_handler.make_bucket() , file_name=myfile.name):
                return Response(
                        {"messages":"file name exist"},
                        status=status.HTTP_400_BAD_REQUEST,
                    )
            else:
                print(myfile.name)
                file_data = myfile.read();
                fileStoreInMinio = minio_handler.put_object(
                    file_data=BytesIO(file_data),
                    file_name=myfile.name,
                    content_type="application/octet-stream",
                ) 
                file=  FileSharing.objects.create()
                file.file_name=fileStoreInMinio["file_name"]
                file.url= fileStoreInMinio['url']
                file.bucket_name= fileStoreInMinio['bucket_name']
                file.uploaded_at=datetime.now()
                file.save();

                return Response(
                    {"messages":"success","url":file.url},
                    status=status.HTTP_201_CREATED,
                )
        return Response(
            {"messages":"filed","url":""},
            status=status.HTTP_400_BAD_REQUEST,
        )
        #return HttpResponseRedirect(redirect_to=cloneRequest.build_absolute_uri('/api/fileSharing/upload')) # uncomment for testing

class RemoveFileHandler(APIView):
    def post(self,request):
        cloneRequest=request
        jsonDelete=JSONParser().parse( cloneRequest)
        file_name=jsonDelete.get('file_name')
        url=jsonDelete.get('url')
        q1=FileSharing.objects.get(file_name=file_name,url=url);
        if q1 and minio_handler.check_file_name_exists(bucket_name=minio_handler.make_bucket() , file_name= file_name):
            
            print(file_name)
            print(url)
       
            if minio_handler.remove_object(q1.bucket_name,q1.file_name):
                q1.delete();
                return Response(
                            {"messages":"success"},
                            status=status.HTTP_201_CREATED,
                        )
        
        return Response(
                    {"messages":"file not exist"},
                    status=status.HTTP_400_BAD_REQUEST,
                )
        #return HttpResponseRedirect(redirect_to=cloneRequest.build_absolute_uri('/api/fileSharing/upload')) #uncomment for testing


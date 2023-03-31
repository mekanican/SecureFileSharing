# minio_handler.py
"""Handler for minio."""

import random
from datetime import datetime, timedelta
from io import BytesIO

from minio import Minio  # type: ignore


class MinioHandler():
    """Docstring."""

    __instance = None

    @staticmethod
    def get_instance():
        """Provide a static access method."""
        if not MinioHandler.__instance:
            MinioHandler.__instance = MinioHandler()
        return MinioHandler.__instance

    def __init__(self):
        """Docstring."""
        self.minio_url = "localhost:9000"
        self.access_key = "admin"
        self.secret_key = "password@123"
        self.bucket_name = "django-minio"
        self.client = Minio(
            self.minio_url,
            access_key=self.access_key,
            secret_key=self.secret_key,
            secure=False,
        )
        self.make_bucket()

    def make_bucket(self) -> str:
        """Docstring."""
        if not self.client.bucket_exists(self.bucket_name):
            self.client.make_bucket(self.bucket_name)
        return self.bucket_name

    def presigned_get_object(self, bucket_name, object_name):
        """Docstring."""
        # Request URL expired after 7 days
        url = self.client.presigned_get_object(
            bucket_name=bucket_name,
            object_name=object_name,
            expires=timedelta(days=7),
        )
        return url

    def check_file_name_exists(self, bucket_name, file_name):
        """Docstring."""
        try:
            self.client.stat_object(
                bucket_name=bucket_name,
                object_name=file_name,
            )
            return True
        except Exception as e:
            print(f"[x] Exception: {e}")
            return False

    def put_object(self, file_data, file_name, content_type):
        """Docstring."""
        try:
            datetime_prefix = datetime.now().strftime("%d-%m-%Y_%H-%M-%S")
            object_name = f"{datetime_prefix}___{file_name}"
            while self.check_file_name_exists(
                bucket_name=self.bucket_name,
                file_name=object_name,
            ):
                random_prefix = random.randint(1, 1000)
                object_name = (
                    f"{datetime_prefix}___{random_prefix}___{file_name}"
                )

            self.client.put_object(
                bucket_name=self.bucket_name,
                object_name=object_name,
                data=file_data,
                content_type=content_type,
                length=-1,
                part_size=10 * 1024 * 1024,
            )
            url = self.presigned_get_object(
                bucket_name=self.bucket_name,
                object_name=object_name,
            )
            data_file = {
                "bucket_name": self.bucket_name,
                "file_name": object_name,
                "url": url,
            }
            return data_file
        except Exception as e:
            raise Exception(e)

    def get_object(self, bucket_name, file_name):
        """Docstring."""
        return self.client.get_object(
            bucket_name=bucket_name,
            object_name=file_name,
        )
# Usage:
# MinioHandler is Singleton !, get through get_instance()
# Remember to handle exception
# put_object: Put file to Minio
#   file_data: byte like array wrapped in BytesIO
#       Example:
#       data = open("abc", "rb").read(); BytesIO(data) -> file_data
#   file_name: real name of file
#   content_type: string, MIME type infer from http request!
#       Example:
#       "image/jpeg",
#   https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types
#   RESULT: Json of bucket_name (const), filename modified with timestamp,
#    and url to bucket
#
#   check_file_name_exists: Check filename is in Minio,
#   make sure checking before download
#   bucket_name: default to const MinioClient.bucket_name
# (replace class with object)
#   file_name: filename modified with timestamp
#   RESULT: True | False
# get_object: Download file from Minio
#   ARGUMENTS same as above
#   RESULT: bytes like object


minio_handler = MinioHandler.get_instance()
file_data = open("run.sh", "rb").read()

# Put file to Minio
data_file = minio_handler.put_object(
    file_data=BytesIO(file_data),
    file_name="run.sh",
    content_type="application/octet-stream",
)
print(data_file)

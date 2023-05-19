# minio_handler.py
"""Handler for minio."""

import random
from datetime import datetime, timedelta
from io import BytesIO
from typing import Any, AnyStr

from minio import Minio  # type: ignore

# pylint skip this file
# pylint: skip-file
# mypy do not check type annotations for this file
# mypy: ignore-errors


class MinioHandler():
    """Docstring."""

    __instance = None

    @staticmethod
    def get_instance() -> "MinioHandler":
        """Provide a static access method."""
        if not MinioHandler.__instance:
            MinioHandler.__instance = MinioHandler()
        return MinioHandler.__instance

    def __init__(self) -> None:
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

    def presigned_get_object(self, bucket_name, object_name, ttl=7) -> AnyStr:
        """Docstring."""
        # Request URL expired after 7 days
        url = self.client.presigned_get_object(
            bucket_name=bucket_name,
            object_name=object_name,
            expires=timedelta(days=ttl),
        )
        return url

    def check_file_name_exists(self, bucket_name, file_name) -> bool:
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

    def put_object(self, file_data, file_name, content_type, ttl=7) -> dict[str, Any]:
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
                ttl=ttl
            )
            data_file = {
                "bucket_name": self.bucket_name,
                "file_name": object_name,
                "url": url,
            }
            return data_file
        except Exception as e:
            raise Exception(e)

    def get_object(self, bucket_name, file_name) -> Any:
        """Docstring."""
        return self.client.get_object(
            bucket_name=bucket_name,
            object_name=file_name,
        )

    def remove_object(self,bucket_name,file_name)->Any:
        try:
            self.client.remove_object(
                bucket_name=bucket_name,
                object_name=file_name,
            )
            return True
        except:
            return False

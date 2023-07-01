# pylint: skip-file
# mypy: ignore-errors

import os
import random
from datetime import datetime, timedelta
from typing import Any, AnyStr

from dotenv import load_dotenv
from minio import Minio  # type: ignore

load_dotenv()  # Load environment variables from .env file


class MinioHandler:
    """Handler for minio."""

    __instance = None

    @staticmethod
    def get_instance() -> "MinioHandler":
        """Provide a static access method."""
        if not MinioHandler.__instance:
            MinioHandler.__instance = MinioHandler()
        return MinioHandler.__instance

    def __init__(self) -> None:
        """Constructor."""
        self.minio_url = os.getenv("MINIO_ENDPOINT")
        self.access_key = os.getenv("MINIO_ACCESS_KEY")
        self.secret_key = os.getenv("MINIO_SECRET_KEY")
        self.bucket_name = os.getenv("MINIO_BUCKET_NAME")

        self.client = Minio(
            self.minio_url,
            access_key=self.access_key,
            secret_key=self.secret_key,
            secure=True,
        )
        self.make_bucket()

    def make_bucket(self) -> str:
        """Make bucket if not exists."""
        if not self.client.bucket_exists(self.bucket_name):
            self.client.make_bucket(self.bucket_name)
        return self.bucket_name

    def presigned_get_object(self, bucket_name, object_name, ttl=7) -> AnyStr:
        """Presigned get object."""
        # Request URL expired after 7 days
        url = self.client.presigned_get_object(
            bucket_name=bucket_name,
            object_name=object_name,
            expires=timedelta(days=ttl),
        )
        return url

    def check_file_name_exists(self, bucket_name, file_name) -> bool:
        """Check if file name exists in bucket."""
        try:
            self.client.stat_object(
                bucket_name=bucket_name,
                object_name=file_name,
            )
            return True
        except Exception as e:
            print(f"[x] Exception: {e}")
            return False

    def put_object(self, file_data, file_name, content_type, ttl=7) -> dict:
        """Put object to minio."""
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
                ttl=ttl,
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
        """Get object from minio."""
        return self.client.get_object(
            bucket_name=bucket_name,
            object_name=file_name,
        )

    def remove_object(self, bucket_name, file_name) -> Any:
        try:
            self.client.remove_object(
                bucket_name=bucket_name,
                object_name=file_name,
            )
            return True
        except Exception:
            return False

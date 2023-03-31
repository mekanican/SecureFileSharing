set -xe
isort .
flake8 . --show-source

pylint ./sfs
pylint ./sfs/file_sharing
pylint ./sfs/sfs

mypy .

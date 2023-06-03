set -xe
isort .

pylint ./apps/ --ignore=types

set -xe
isort .

# pylint ignore type hints
pylint ./apps/ --ignore=types

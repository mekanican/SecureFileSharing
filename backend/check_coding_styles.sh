set -xe
isort .
# flake8 . --show-source

# pylint ignore type hints
pylint ./apps/

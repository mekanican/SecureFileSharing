set -xe
isort .
flake8 . --show-source

# pylint ignore type hints
pylint ./apps/ --disable=C0114,C0115,C0116 --ignore=types.py

mypy ./apps/

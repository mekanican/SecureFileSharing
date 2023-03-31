set -xe
isort .
flake8 . --show-source
pylint .
mypy .

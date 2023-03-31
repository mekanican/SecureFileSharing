pyenv activate secure-file-sharing-server

pip install --upgrade pip

pip install -r requirements/development.txt

# Start the first process
python ./SFS/manage.py livereload &

# Start the second process
python ./SFS/manage.py runserver
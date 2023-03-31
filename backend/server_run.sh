pyenv activate secure-file-sharing-server

pip install --upgrade pip

pip install -r requirements/development.txt

# Start the first process
python ./sfs/manage.py livereload &

# Start the second process
python ./sfs/manage.py runserver
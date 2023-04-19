pyenv activate secure-file-sharing-server

# pip install --upgrade pip

# pip install -r requirements/development.txt

# Start the first process
# python ./sfs/manage.py livereload &

python ./sfs/manage.py makemigrations

python ./sfs/manage.py migrate

# Start the second process
python ./sfs/manage.py runserver


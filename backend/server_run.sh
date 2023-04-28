# pyenv activate secure-file-sharing-server

# pip install --upgrade pip

# pip install -r requirements/development.txt

# Start the first process
# python ./sfs/manage.py livereload &

python ./manage.py makemigrations

python ./manage.py migrate

# Run server on port 8090
python ./manage.py runserver 8090


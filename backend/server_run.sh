pyenv activate secure-file-sharing-server

# pip install --upgrade pip

# pip install -r requirements/development.txt

# Start the first process
<<<<<<< Updated upstream

python ./sfs/manage.py livereload &
=======
# python ./sfs/manage.py livereload &

python ./sfs/manage.py makemigrations

python ./sfs/manage.py migrate
>>>>>>> Stashed changes

# Start the second process
python ./sfs/manage.py runserver


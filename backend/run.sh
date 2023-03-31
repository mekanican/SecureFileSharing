#!/bin/sh

# Start the first process
python ./SFS/manage.py livereload &

# Start the second process
python ./SFS/manage.py runserver localhost:6969 & 

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?
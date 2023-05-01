#!/bin/sh

# Start the first process
python ./manage.py livereload &

  
# Start the second process
python ./manage.py runserver localhost:6969 & 
  
# Wait for any process to exit
wait -n
  

# Exit with status of process that exited first
exit $?

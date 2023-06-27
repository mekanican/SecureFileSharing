# base image  
FROM python:3.11-bullseye

# set work directory  
RUN mkdir -p /home/app/webapp

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y default-libmysqlclient-dev && rm -rf /var/lib/apt/lists/*

# where your code lives  
WORKDIR /home/app/webapp

# set environment variables  
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1  

# install dependencies  
RUN pip install --upgrade pip  

# copy whole project to your docker home directory. 
COPY . /home/app/webapp  
# run this command to install all dependencies  
RUN pip install -r requirements/development.txt  
RUN pip install django-extensions
# port where the Django app runs  
EXPOSE 8000  
# start server  
CMD python manage.py migrate&&python manage.py runserver 8000

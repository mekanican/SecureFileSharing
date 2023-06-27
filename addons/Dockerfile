# base image  
FROM python:3.11-bullseye

# set work directory  
RUN mkdir -p /home/app/webapp

# where your code lives  
WORKDIR /home/app/webapp

# set environment variables  
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1  

# install dependencies  
RUN pip install --upgrade pip  

# copy whole project to your docker home directory. 
COPY . /home/app/webapp  
# port where the Django app runs  
EXPOSE 9087  
# start server  
CMD python run.py

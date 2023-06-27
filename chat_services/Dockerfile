FROM node:20-bullseye

# set work directory  
RUN mkdir -p /home/app/webapp

# where your code lives  
WORKDIR /home/app/webapp

RUN npm install -g pnpm

# copy whole project to your docker home directory. 
COPY . /home/app/webapp  

EXPOSE 3400
EXPOSE 23432

RUN pnpm i
CMD node index.js

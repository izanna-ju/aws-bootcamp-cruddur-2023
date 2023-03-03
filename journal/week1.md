# Week 1 — App Containerization

## 1. Created dockerfile for both frontend and backend image
 - Dockerfile for frontend image
```
FROM node:16.18

ENV PORT=3000

WORKDIR /frontend-react-js
COPY . /frontend-react-js

RUN npm install
RUN apt-get update

EXPOSE ${PORT}
CMD ["npm", "start"]
```

 - Dockerfile for backend image
```
FROM python:3.10-slim-buster

WORKDIR /backend-flask

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
COPY . .
ENV FLASK_ENV=development

EXPOSE ${PORT}
CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0", "--port=4567"]
```

## 2. Implement CMD command as an external script
I created a docker-script.sh file at the ./backend-flask directory and added the following scripts to implement the CMD command as an external script
```
#!/usr/bin/bash

cd /workspace/aws-bootcamp-cruddur-2023/backend-flask

export FRONTEND_URL="*"
export BACKEND_URL="*"

python3 -m flask run --host=0.0.0.0 --port=4567
```
![CMD External script](https://github.com/izanna-ju/aws-bootcamp-cruddur-2023/blob/main/journal/assets/week1/CMD-external-script.png?raw=true "External script")

## 3. Add endpoints for notification
Following the instructional video guide, I used openapi to create endpoint for my notification page that returns a set of activities.
![Notification endpoints](https://github.com/izanna-ju/aws-bootcamp-cruddur-2023/blob/main/journal/assets/week1/defined-api-endpoints.png?raw=true "Notification endpoints")
![Notification Page](https://github.com/izanna-ju/aws-bootcamp-cruddur-2023/blob/main/journal/assets/week1/add-notifications.png?raw=true "Notification Page")

##4. Tag and push frontend-react-js and backend-flask Images to DockerHub
To connect to docker hub, first I had to ran the command below on the terminal to authenticate and connect my gitpod workspace to my docker account
```
docker login
```
![DockerHub Auth](https://github.com/izanna-ju/aws-bootcamp-cruddur-2023/blob/main/journal/assets/week1/authenticate-docker-hub.png?raw=true "DockerHub Auth")

Then, I build and tag both frontend and backend images as 1.0 and push to different repositories in my dockerhub account
### Build, tag and push frontend image to dockerhub repo
![Build FE image](https://github.com/izanna-ju/aws-bootcamp-cruddur-2023/blob/main/journal/assets/week1/build-frontend-image.png?raw=true "Build Frontend Image")
![Tag FE Image](https://github.com/izanna-ju/aws-bootcamp-cruddur-2023/blob/main/journal/assets/week1/push-docker-frontend-image.png?raw=true "Tag FE image")
![Frontend Repo](https://github.com/izanna-ju/aws-bootcamp-cruddur-2023/blob/main/journal/assets/week1/docker-frontend-repo.png?raw=true "FE Repo")




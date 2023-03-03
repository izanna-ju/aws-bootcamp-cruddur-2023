# Week 1 — App Containerization

## 1. Implement CMD command as an external script
I created a docker-script.sh file at the ./backend-flask directory and added the following scripts to implement the CMD command as an external script
```
#!/usr/bin/bash

cd /workspace/aws-bootcamp-cruddur-2023/backend-flask

export FRONTEND_URL="*"
export BACKEND_URL="*"

python3 -m flask run --host=0.0.0.0 --port=4567
```
![CMD External script](https://github.com/izanna-ju/aws-bootcamp-cruddur-2023/blob/main/journal/assets/week1/CMD-external-script.png?raw=true "External script")

## 2. Add endpoint for notifications
Following the instructional video guide, I used openapi to create endpoint for my notification page that returns a set of activities.
![Notification endpoints](https://github.com/izanna-ju/aws-bootcamp-cruddur-2023/blob/main/journal/assets/week1/defined-api-endpoints.png?raw=true "Notification endpoints")
**2.1 Notification endpoint**
![Notification Page](https://github.com/izanna-ju/aws-bootcamp-cruddur-2023/blob/main/journal/assets/week1/add-notifications.png?raw=true "Notification Page")
**2.2 Notification Page**

## 3. Tag and push frontend-react-js and backend-flask Images to DockerHub
To connect to docker hub, first, I had to run the command below on the terminal to authenticate and connect my gitpod workspace to my docker account
```
docker login
```
![DockerHub Auth](https://github.com/izanna-ju/aws-bootcamp-cruddur-2023/blob/main/journal/assets/week1/authenticate-docker-hub.png?raw=true "DockerHub Auth")
**3.1 Docker Login**

Then, I build and tag both frontend and backend images as versions 1.0 and push to different repositories in my dockerhub account
### Build, tag and push frontend image to dockerhub repo
![Build FE image](https://github.com/izanna-ju/aws-bootcamp-cruddur-2023/blob/main/journal/assets/week1/build-frontend-image.png?raw=true "Build Frontend Image")
**3.2 Build Frontend Image**
![Tag FE Image](https://github.com/izanna-ju/aws-bootcamp-cruddur-2023/blob/main/journal/assets/week1/push-docker-frontend-image.png?raw=true "Tag FE image")
**3.3 Tag Frontend Image**
![Frontend Repo](https://github.com/izanna-ju/aws-bootcamp-cruddur-2023/blob/main/journal/assets/week1/docker-frontend-repo.png?raw=true "FE Repo")
**3.4 Frontend Docker repository**

### Build, tag and push backend image to dockerhub repo
![Tag BE Image](https://github.com/izanna-ju/aws-bootcamp-cruddur-2023/blob/main/journal/assets/week1/push-docker-be-image.png?raw=true "Tag BE image")
**3.5 Tag Backend Image**
![Backend Repo](https://github.com/izanna-ju/aws-bootcamp-cruddur-2023/blob/main/journal/assets/week1/docker-backend-repo.png?raw=true "BE Repo")
**3.6 Backend Docker Repository**

## 4. Multi-stage build on Dockerfile
I implemented multi-stage builds on both my Dockerfiles, this add the necessary dependencies and pulls images needed by both my frontend and backend application to run. This significantly reduces the dependencies I needed to install in my gitpod workspace when running the image defined in the Dockerfile(s)

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

## 5. Health check for various services in the docker compose v3 file
I added health checks in the docker-compose.yaml file for both frontend and backend services

 - Health Check for Backend image
```
backend-flask:
    environment:
      FRONTEND_URL: "https://3000-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
      BACKEND_URL: "https://4567-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
    build: ./backend-flask
    ports:
      - "4567:4567"
    volumes:
      - ./backend-flask:/backend-flask
    healthcheck:
      test: curl --fail https://4567-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST} || exit 1
      interval: 60s
      retries: 5
      start_period: 20s
      timeout: 10s
```
 - Health check for Frontend Image
```
 frontend-react-js:
    environment:
      REACT_APP_BACKEND_URL: "https://4567-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
    build: ./frontend-react-js
    ports:
      - "3000:3000"
    volumes:
      - ./frontend-react-js:/frontend-react-js
    healthcheck:
      test: curl --fail https://3000-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST} || exit 1
      interval: 60s
      retries: 5
      start_period: 20s
      timeout: 10s
```

## 6. Install docker in local machine
I installed docker in my local machine, run the docker-compose file that builds the images and sets up the containers for backend-flask, frontend-react-js, postgres and dynamodb.
![Docker Version](https://github.com/izanna-ju/aws-bootcamp-cruddur-2023/blob/main/journal/assets/week1/docker-installed-locally.png?raw=true "Docker Version")
**6.1 Docker Version**
![Containers running locally](https://github.com/izanna-ju/aws-bootcamp-cruddur-2023/blob/main/journal/assets/week1/containers-running-local.png?raw=true "Containers running locally")
**6.2 Containers running locally**

## 7. Launch an EC2 instance with docker install
I login into the aws management console using my iam user account and launch an ec2 amazon linux instance. On the **user data** section of the ec2 instance set up, I entered the script below to update the linux packages, installed docker and start the docker service
```
#!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start
```
Then I launched the ec2 instance
![EC2 instance](https://github.com/izanna-ju/aws-bootcamp-cruddur-2023/blob/main/journal/assets/week1/created-EC2.png)
**7.1 EC2 instance**

#### SSH into instance to confirm docker installed successfully and pull the hello world image to ensure ec2 instance can pull images from dockerhub
![SSH login](https://github.com/izanna-ju/aws-bootcamp-cruddur-2023/blob/main/journal/assets/week1/ec2-docker-install.png)








# Week 1 — App Containerization

## Created dockerfile for both frontend and backend image
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
## Implement CMD command as an external script
I created a docker-script.sh file at the ./backend-flask directory and added the following scripts to implement the CMD command as an external script
```
#!/usr/bin/bash

cd /workspace/aws-bootcamp-cruddur-2023/backend-flask

export FRONTEND_URL="*"
export BACKEND_URL="*"

python3 -m flask run --host=0.0.0.0 --port=4567
```
![Run CMD external script](https://github.com/izanna-ju/aws-bootcamp-cruddur-2023/blob/main/journal/assets/week1/CMD-external-script.png)

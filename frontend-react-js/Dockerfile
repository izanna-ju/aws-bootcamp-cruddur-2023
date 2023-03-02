FROM node:16.18

ENV PORT=3000

WORKDIR /frontend-react-js
COPY . /frontend-react-js

RUN npm install
RUN apt-get update

EXPOSE ${PORT}
CMD ["npm", "start"]
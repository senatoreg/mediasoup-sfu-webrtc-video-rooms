FROM node:current-slim AS builder

WORKDIR /app
#RUN apt-get update
RUN apt-get update && apt-get install -y \
    make \
    gcc \
    g++ \
    python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
COPY package-lock.json .
COPY package.json .
RUN npm install

FROM node:current-slim
WORKDIR /app
COPY --from=builder /app/node_modules node_modules
COPY package-lock.json .
COPY package.json .
COPY src/Room.js src/Peer.js src/app.js src
COPY ssl ssl
COPY public public

EXPOSE 3016
EXPOSE 10000-15000

#RUN npm i -g nodemon

CMD npm start

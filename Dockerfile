###########
## build image
###########
FROM node:18-buster as builder

RUN mkdir -p /usr/src/next-nginx
WORKDIR /usr/src/next-nginx
COPY app/next-app/package.json package.json
RUN npm install
COPY app/next-app .
RUN npm run build

###########
## production application image
###########
FROM nginx:1.21.0-alpine as production

RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /usr/src/next-nginx/out /usr/share/nginx/html

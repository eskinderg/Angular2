### STAGE 1: Build ###
# Label our stage as 'builder'

FROM node:8-alpine as builder

COPY package.json ./

RUN npm set progress=false && npm config set depth 0
# RUN npm --version
## Storing node modules on a separate layer will prevent unnecessary npm installs at each build
RUN npm i
RUN mkdir /ng-app
RUN cp -R ./node_modules ./ng-app

WORKDIR /ng-app

COPY . .

## Build the angular app in production mode and store the artifacts in dist folder
RUN npm run build-prod-ngsw

### STAGE 2: Setup ###
FROM nginx:1.13.3-alpine

## Copy our default nginx config
COPY .docker/default.conf /etc/nginx/conf.d/

## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

## From 'builder' stage copy over the artifacts in dist folder to default nginx public folder
COPY --from=builder /ng-app/dist /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]

EXPOSE 80
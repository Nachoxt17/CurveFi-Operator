FROM node:16-alpine

# User ID for the django user we're creating. The builder can set this to the
# host user's ID to avoid file permissions problems.
ARG USER_ID=1001

# install unix deps
RUN apk add --no-cache git
ENV PYTHONUNBUFFERED=1
RUN apk add g++ make git
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN apk add --update --no-cache yarn
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

# create app dir
# Create the user and group
RUN addgroup --gid $USER_ID -S hardhat && adduser --uid $USER_ID -S hardhat -G hardhat

WORKDIR /app
RUN chown -R hardhat:hardhat /app

COPY --chown=hardhat:hardhat package.json package.json

# install deps
COPY package.json package.json
COPY yarn.lock yarn.lock
COPY --chown=hardhat:hardhat / ./
USER hardhat
RUN npm i
RUN yarn install

# copy project files
COPY ./ ./


#!/usr/bin/env bash

# Use this script to start a docker container with a MySQL database
#
# REQUIREMENTS:
# - Docker installed - https://docs.docker.com/engine/install/
# - .env file with the following variables:
#  MYSQL_URI=mysql://root:password@localhost:3306/dbname
# Replace `password` with your desired password
# Replace `dbname` with your desired database name
# USAGE:
# - Run this script in the root of your project directory
# - `bash start-database.sh`

DB_CONTAINER_NAME="your-database-container-name"


# import env variables from .env
set -a
source .env

DB_PASSWORD=$(echo "$MYSQL_URI" | awk -F':' '{print $2}' | awk -F'@' '{print $1}')
DB_PORT=$(echo "$MYSQL_URI" | awk -F':' '{print $3}' | awk -F')/' '{print $1}')
DB_NAME=$(echo "$MYSQL_URI" | awk -F'/' '{print $2}')

if ! [ -x "$(command -v docker)" ]; then
  echo -e "Docker is not installed. Please install docker and try again.\nDocker install guide: https://docs.docker.com/engine/install/"
  exit 1
fi

if [ "$(docker ps -q -f name=$DB_CONTAINER_NAME)" ]; then
  echo "Database container '$DB_CONTAINER_NAME' already running"
  exit 0
fi

if [ "$(docker ps -q -a -f name=$DB_CONTAINER_NAME)" ]; then
  docker start "$DB_CONTAINER_NAME"
  echo "Existing database container '$DB_CONTAINER_NAME' started"
  exit 0
fi

if [ "$DB_PASSWORD" == "password" ]; then
  echo "You are using the default database password"
  read -p "Should we generate a random password for you? [y/N]: " -r REPLY
  if ! [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Please set a password in the .env file and try again"
    exit 1
  fi
  DB_PASSWORD=$(openssl rand -base64 12 | tr '+/' '-_')
  sed -i -e "s#:password@#:$DB_PASSWORD@#" .env
fi

docker run -d \
    --name $DB_CONTAINER_NAME \
    -e MYSQL_ROOT_PASSWORD="$DB_PASSWORD" \
    -e MYSQL_DATABASE="$DB_NAME" \
    -p "$DB_PORT":3306 \
    docker.io/mysql && \
     echo "Database container '$DB_CONTAINER_NAME' was successfully created"

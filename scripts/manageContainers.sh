#!/bin/bash

DATA_VOLUME_NAME="mongo_data_mstr"
#DATA_VOLUME_NAME="mongo_data_test"

DB_IMAGE_NAME="dennis/mongo_db"
DB_CONTAINER_NAME="mongo_db"
DB_CONTAINER_ALIAS="mongo_db"

NODE_IMAGE_NAME="dennis/node_server"
NODE_SERVER_NAME="nodeApp"

# Remove old Node Server container.
sh ./removeContainer.sh ${NODE_SERVER_NAME}

# Remove old DB container.
sh ./removeContainer.sh ${DB_CONTAINER_NAME}

echo "-->docker run -d -p 27017:27017 -p 28017:28017 --volumes-from " ${DATA_VOLUME_NAME} " --name "${DB_CONTAINER_NAME} ${DB_IMAGE_NAME} "mongod --smallfiles"
# Build new Mongo DB container from an existing DB image, and connect it to an external data volume
docker run -d -p 27017:27017 -p 28017:28017 --volumes-from ${DATA_VOLUME_NAME} --name ${DB_CONTAINER_NAME} ${DB_IMAGE_NAME} mongod --smallfiles

echo "-->docker run -d -p 3000:3000 --name " ${NODE_SERVER_NAME} " --link " ${DB_CONTAINER_ALIAS}":"${DB_CONTAINER_NAME} ${NODE_IMAGE_NAME}
# Build a new node server container with the new mongo DB configuration
docker run -d -p 3000:3000 --name ${NODE_SERVER_NAME} --link ${DB_CONTAINER_ALIAS}:${DB_CONTAINER_NAME} ${NODE_IMAGE_NAME}
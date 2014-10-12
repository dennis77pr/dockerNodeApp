#!/bin/bash

DB_NAME="nodemongo1_db"
DB_BACKUP_LOC="bkup/mongo/stable"

DATA_VOLUME_NAME="mongo_data_consumed"
DATA_VOLUME_IMAGE="dennis/mongo_data"

DB_IMAGE_NAME="dennis/mongo_db"
DB_CONTAINER_NAME="mongo_db"
DB_CONTAINER_ALIAS="mongo_db"

NODE_IMAGE_NAME="dennis/node_server"
NODE_SERVER_NAME="nodeApp"

function docker-ip(){
    boot2docker ip 2> /dev/null
}

# Remove old Node Server container.
sh ./removeContainer.sh ${NODE_SERVER_NAME}

# Remove old DB container.
sh ./removeContainer.sh ${DB_CONTAINER_NAME}

# Remove any data volumes with this name.
sh ./removeContainer.sh ${DATA_VOLUME_NAME}

echo "-->docker run -i -t --name " ${DATA_VOLUME_NAME} ${DATA_VOLUME_IMAGE}
# create a new data volume
docker run -i -t --name ${DATA_VOLUME_NAME} ${DATA_VOLUME_IMAGE} | exit

echo "-->docker run -d -p 27017:27017 -p 28017:28017 --volumes-from " ${DATA_VOLUME_NAME} " --name "${DB_CONTAINER_NAME} ${DB_IMAGE_NAME} "mongod --smallfiles"
# Build new Mongo DB container from an existing DB image, and connect it to an external data volume
docker run -d -p 27017:27017 -p 28017:28017 --volumes-from ${DATA_VOLUME_NAME} --name ${DB_CONTAINER_NAME} ${DB_IMAGE_NAME} mongod --smallfiles

echo "waiting 3 seconds to make sure DB is up before restore."
sleep 3
echo "-->mongorestore --host " $(docker-ip) "--port 27017 " ${DB_BACKUP_LOC}"/"${DB_NAME}
# Restore the back up data to the test data volume
mongorestore --host $(docker-ip) --port 27017 ${DB_BACKUP_LOC}/${DB_NAME}

echo "-->docker run -d -p 3000:3000 --name " ${NODE_SERVER_NAME} " --link " ${DB_CONTAINER_ALIAS}":"${DB_CONTAINER_NAME} ${NODE_IMAGE_NAME}
# Build a new node server container with the new mongo DB configuration
docker run -d -p 3000:3000 --name ${NODE_SERVER_NAME} --link ${DB_CONTAINER_ALIAS}:${DB_CONTAINER_NAME} ${NODE_IMAGE_NAME}
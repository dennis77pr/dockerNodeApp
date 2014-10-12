#!/bin/bash

DATA_VOLUME_NAME="mongo_data_temp"
DATA_VOLUME_IMAGE="dennis/mongo_data"

DB_IMAGE_NAME="dennis/mongo_db"
DB_CONTAINER_NAME="mongo_db_temp"
DB_CONTAINER_TO_BACKUP="mongo_db"

DB_NAME="nodemongo1_db"
DB_BACKUP_LOC="bkup/mongo/stable"

function docker-ip(){
    boot2docker ip 2> /dev/null
}

# Remove any data volumes with this name.
sh ./removeContainer.sh ${DATA_VOLUME_NAME}

# backup mongo DB 
docker start ${DB_CONTAINER_TO_BACKUP}

echo "waiting 3 seconds to make sure DB is up before taking backup."
sleep 3
mongodump --host $(docker-ip) --port 27017 --db ${DB_NAME} --out ${DB_BACKUP_LOC}

docker stop ${DB_CONTAINER_TO_BACKUP}

# create a new data volume
docker run -i -t --name ${DATA_VOLUME_NAME} ${DATA_VOLUME_IMAGE} | exit

# Start a new mongodb container with the test db data volumes connected
docker run -d -p 27017:27017 -p 28017:28017 --volumes-from ${DATA_VOLUME_NAME} --name ${DB_CONTAINER_NAME} ${DB_IMAGE_NAME} mongod --smallfiles

echo "waiting 3 seconds to make sure DB is up before restore."
sleep 3

# Restore the back up data to the test data volume
mongorestore --host $(docker-ip) --port 27017 ${DB_BACKUP_LOC}/${DB_NAME}

echo "restore completed"

# Remove temp DB container.
sh ./removeContainer.sh ${DB_CONTAINER_NAME}
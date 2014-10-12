#!/bin/bash

CONTAINER_NAME=$1

# Remove old container.
echo "-->docker stop" ${CONTAINER_NAME}
docker stop ${CONTAINER_NAME}
echo "-->docker rm" ${CONTAINER_NAME}
docker rm ${CONTAINER_NAME}
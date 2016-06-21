#! /bin/bash
# Usage: ./build.sh [IMAGE_NAME]
#
# IMAGE_NAME defaults to "riak-cs" if it is not specified.

IMAGE_NAME="$1"
if [ -z "$IMAGE_NAME" ]; then
    IMAGE_NAME="riak-cs"
fi

if [ "$DOCKER_RIAKCS_RM" == '1' ]; then
    # forcibly remove container, image and associated volumes
    docker rm -fv $(docker ps -a | grep "$IMAGE_NAME" | awk '{print $1}')
    docker rmi "$IMAGE_NAME"
fi

docker build -t "$IMAGE_NAME:latest" .
RCODE="$?"

if [ "$RCODE" == "0" -a "$DOCKER_RIAKCS_START" == "yes" ]; then
    echo "Starting $IMAGE_NAME..."
    docker run -d -p 9980:9980 -p 8098:8098 "$IMAGE_NAME"
fi

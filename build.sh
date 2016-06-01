if [ "$DOCKER_RIAKCS_RM" == '1' ]; then
    # forcibly remove container, image and associated volumes
    docker rm -fv $(docker ps -a | grep "dimagi/riak-cs" | awk '{print $1}')
    docker rmi dimagi/riak-cs
fi

docker build -t dimagi/riak-cs:latest .
RCODE="$?"

if [ "$RCODE" == "0" -a "$DOCKER_RIAKCS_NO_START" == "" ]; then
    echo "starting container..."
    docker run -d -p 8080:8080 -p 8098:8098 dimagi/riak-cs
fi

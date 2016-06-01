if [ "$RM" == '1' ]; then
    docker rm -fv $(docker ps -a | grep "dimagi/riak-cs" | awk '{print $1}')
    docker rmi dimagi/riak-cs
fi

docker build -t dimagi/riak-cs:latest .
RCODE="$?"

if [ "$RCODE" == "0" ]; then
    echo "starting container..."
    docker run -d -p 8080:8080 -p 8098:8098 dimagi/riak-cs
fi

## useful commands to remove failed build containers, images, and volumes
# docker rm $(docker ps -a | grep -E "\bsha256:" | awk '{print $1}')
# docker rmi $(docker images | grep "^<none>" | awk '{print $3}')
# docker volume rm $(docker volume ls -f dangling=true | awk '{ if(NR>1) print $2 }')

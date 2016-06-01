# Riak CS in a docker container

This builds a single Riak CS node with three processes: Riak, Stanchion
and Riak CS. This is for testing and development only; it is not meant
to be used in production.

See `Dockerfile` for container details including volumes and exposed ports.

Admin keys are configured automatically the first time the container starts.
Default values are used:

    admin.key = admin-key
    admin.secret = admin-secret

Note: the services take some time to start and become ready to accept requests
(about 30s on the machine where this was developed).

## Useful docker commands for cleanup after failed builds:

```sh
# Remove failed/partially built containers
docker rm $(docker ps -a | grep -E "\bsha256:" | awk '{ print $1 }')

# Remove failed/partially built images
docker rmi $(docker images | grep "^<none>" | awk '{ print $3 }')

# Remove all dangling docker volumes
docker volume rm $(docker volume ls -f dangling=true | awk '{ if(NR>1) print $2 }')
```

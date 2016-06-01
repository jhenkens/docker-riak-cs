#! /bin/bash
# set insecure admin key/secret for dev/testing
# key:      admin-key
# secret:   admin-secret
set -e

if [ ! -f /var/lib/riak/user-exists ]; then
    IP_ADDRESS=$(ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

    riak-admin wait-for-service riak_kv

    # https://github.com/basho/riak_cs/issues/1074#issuecomment-111110461
    sudo -u riak $(ls -d /usr/lib/riak-cs/erts*)/bin/erl -name n@${IP_ADDRESS} -setcookie riak \
        -eval "io:format(\"~p\", [rpc:call('riak-cs@${IP_ADDRESS}', riak_cs_user, create_user, [\"name\", \"dev@admin.com\", \"admin-key\",  \"admin-secret\"])])." \
        -s init stop -noshell > /var/log/riak/user-creation.log 2>&1

    touch /var/lib/riak/user-exists
fi

#! /bin/bash
# set insecure admin key/secret for dev/testing
# key:      admin-key
# secret:   admin-secret
if [ -f /var/log/riak/user-exists ]; then
    echo "user exists"
else
    host=$(ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
    port=9980
    counter=0
    echo "Waiting for riak-cs at ${host}:${port}..."
    while ! { exec 6<>/dev/tcp/${host}/${port}; } 2>/dev/null
    do
        sleep 1
        let counter=counter+1
        if [ $counter -gt 30 ]; then
            echo "Timeout."
            exit 1
        fi
    done
    if [ -z "$RIAK_USER" ]; then
        echo "Failed to find username"
        exit 1
    fi
    if [ -z "$RIAK_PASS" ]; then
        echo "Failed to find password"
        exit 1
    fi

    # https://github.com/basho/riak_cs/issues/1074#issuecomment-111110461
    sudo -u riak $(ls -d /usr/lib/riak-cs/erts*)/bin/erl \
        -noshell -name n@127.0.0.1 -setcookie riak \
        -eval 'io:format("~p", [
            rpc:call(
                '"'"'riak-cs@127.0.0.1'"'"',
                riak_cs_user,
                create_user,
                ["admin", "admin@admin.com", "'$RIAK_USER'",  "'$RIAK_PASS'"]
            )
        ]).' -s init stop > /var/log/riak/session-user-creation.log 2>&1

    cat /var/log/riak/session-user-creation.log >> /var/log/riak/user-creation.log
    if grep -Eq '{ok,|,user_already_exists}' /var/log/riak/session-user-creation.log; then
        touch /var/log/riak/user-exists
    else
        echo "admin key not set"
        cat /var/log/riak/session-user-creation.log
    fi
fi

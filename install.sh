#! /bin/sh
set -e

curl https://packagecloud.io/install/repositories/basho/riak/script.deb.sh > /tmp/riak-install.sh
curl https://packagecloud.io/install/repositories/basho/riak-cs/script.deb.sh > /tmp/riak-cs-install.sh
curl https://packagecloud.io/install/repositories/basho/stanchion/script.deb.sh > /tmp/stanchion-install.sh

chmod +x /tmp/riak-install.sh /tmp/riak-cs-install.sh /tmp/stanchion-install.sh
/tmp/riak-install.sh
/tmp/riak-cs-install.sh
/tmp/stanchion-install.sh

apt-get install -y riak=2.1.1-1 riak-cs=2.1.0-1 stanchion=2.1.0-1

mkdir -p /etc/service/riak /etc/service/riak-cs /etc/service/stanchion

rm -rfv \
    /var/lib/riak \
    /var/lib/riak-cs \
    /var/lib/stanchion \
    /var/log/riak \
    /var/log/riak-cs \
    /var/log/stanchion

# symlinks for data dirs (all data and logs reside in /var/lib/riak-vol)
ln -s /var/lib/riak-vol/riak /var/lib/riak
ln -s /var/lib/riak-vol/riak-cs /var/lib/riak-cs
ln -s /var/lib/riak-vol/stanchion /var/lib/stanchion
ln -s /var/lib/riak-vol/log/riak /var/log/riak
ln -s /var/lib/riak-vol/log/riak-cs /var/log/riak-cs
ln -s /var/lib/riak-vol/log/stanchion /var/log/stanchion

# clean up
rm -v /tmp/*

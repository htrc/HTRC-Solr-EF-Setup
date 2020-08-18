#!/bin/bash

systemctl_user=${1:-www-data}
systemctl_group=${1:-htrc}

zookeeper_home="zookeeper-for-solr8"

echo "****"
echo "* Changing user:group ownership to (and adding group-write permission for):"
echo "*   $systemctl_user:$systemctl_group"
echo "* recursively for:"
echo "*  $zookeeper_home/{data,logs}"
echo "****"

sudo chown -R $systemctl_user "$zookeeper_home/data" "$zookeeper_home/logs"
sudo chgrp -R $systemctl_group "$zookeeper_home/data" "$zookeeper_home/logs"
sudo chmod -R g+w "$zookeeper_home/data" "$zookeeper_home/logs"

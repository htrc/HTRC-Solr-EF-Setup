#!/bin/bash

systemctl_user=${1:-www-data}
systemctl_group=${2:-htrc}

zookeeper_home="zookeeper-for-solr8"

echo "****"
echo "* Changing user:group ownership to (and adding group-write permission for):"
echo "*   $systemctl_user:$systemctl_group"
echo "* recursively for:"
#echo "*  $zookeeper_home/{data,logs}"
echo "*  $zookeeper_home/"
echo "****"

sudo chown -R $systemctl_user "$zookeeper_home/"
sudo chgrp -R $systemctl_group "$zookeeper_home/"
sudo chmod -R g+w "$zookeeper_home/" 

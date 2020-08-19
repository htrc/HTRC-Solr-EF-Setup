#!/bin/bash




systemctl_user=${1:-www-data}
systemctl_group=${2:-htrc}

solr8_shard_dirs='/disk*/htrc-ef-solr8-shards/'

echo "****"
echo "* Changing user:group ownership to (and adding group-write permission for):"
echo "*   $systemctl_user:$systemctl_group"
echo "* recursively for:"
echo "*  $solr8_shard_dirs"
echo "****"



sudo chown -R $systemctl_user  $solr8_shard_dirs
sudo chgrp -R $systemctl_group  $solr8_shard_dirs
sudo chmod -R g+w $solr8_shard_dirs


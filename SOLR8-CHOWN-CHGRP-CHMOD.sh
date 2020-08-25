#!/bin/bash



systemctl_user=${1:-www-data}


if [ -d "/disk1/htrc-ef-solr8-shards/" ] ; then
    systemctl_group=${2:-htrc}
    solr8_shard_dirs='/disk*/htrc-ef-solr8-shards/'
else
    systemctl_group=${2:-htrc-solr}
    solr8_shard_dirs='/solr-data/node*/htrc-ef-solr8-shards/'
fi

echo "****"
echo "* Changing user:group ownership to (and adding group-write permission for):"
echo "*   $systemctl_user:$systemctl_group"
echo "* recursively for:"
echo "*  $solr8_shard_dirs"
echo "****"


echo ""
echo "Top-level full dir listing:"
echo ""

sudo chown -R $systemctl_user   $solr8_shard_dirs
sudo chgrp -R $systemctl_group  $solr8_shard_dirs
sudo chmod -R g+s $solr8_shard_dirs
sudo chmod -R g+w $solr8_shard_dirs

ls -ld $solr8_shard_dirs
echo ""

echo "Also fixing up: "
echo "  $SOLR8_SERVER_BASE_JETTY_DIR/"
sudo chown -R $systemctl_user $SOLR8_SERVER_BASE_JETTY_DIR/
sudo chmod -R g+w $SOLR8_SERVER_BASE_JETTY_DIR/.

ls -l $SOLR8_SERVER_BASE_JETTY_DIR/.
echo ""


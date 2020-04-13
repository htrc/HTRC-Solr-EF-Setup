#!/bin/bash

zookeeper8_config_file="$ZOOKEEPER8_HOME/conf/zoo.cfg"
zookeeper8_data_dir="$ZOOKEEPER8_HOME/data"
zookeeper8_port=${ZOOKEEPER8_SERVER##*:}
zookeeper8_admin_port=$((zookeeper8_port+1))

if [ ! -d "$zookeeper8_data_dir" ] ; then
    echo "* Creating Zookeeper for Solr8 dataDir:"
    echo "*   $zookeeper8_data_dir"
    mkdir "$zookeeper8_data_dir"
fi
      
echo "****"
echo "* Generating $zookeeper8_config_file"
echo "*   Zookeeper for Solr8 server port: $zookeeper8_port"
echo "*   Zookeeper for Solr8 server admin port: $zookeeper8_admin_port"

cat conf/zoo8.cfg.in \
    | sed "s%@zookeeper8-data-dir@%$zookeeper8_data_dir%g" \
    | sed "s%@zookeeper8-port@%$zookeeper8_port%g" \
    | sed "s%@zookeeper8-admin-port@%$zookeeper8_admin_port%g" \
	  > "$zookeeper8_config_file"

echo "****"

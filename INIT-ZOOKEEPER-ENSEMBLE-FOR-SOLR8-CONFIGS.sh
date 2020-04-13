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

short_hostname=`uname -n | sed 's/\..*//'`
    
cat conf/zoo8-ensemble.cfg.in \
    | sed "s%@zookeeper8-data-dir@%$zookeeper8_data_dir%g" \
    | sed "s%@zookeeper8-port@%$zookeeper8_port%g" \
    | sed "s%@zookeeper8-admin-port@%$zookeeper8_admin_port%g" \
	  > "$zookeeper8_config_file"
echo "***!!!!!!!!"
echo "*** Warning: There are hard-wired Zookeeper port numbers for solr3,solr4,solr5 in conf/zoo8-ensemble.cfg.in"
echo "***!!!!!!!!"
    
if [ "$short_hostname" = "is-solr3" ] ; then
    echo "1" > "$zookeeper8_data_dir/myid"
fi
if [ "$short_hostname" = "is-solr4" ] ; then
    echo "2" > "$zookeeper8_data_dir/myid"
fi
if [ "$short_hostname" = "is-solr5" ] ; then
    echo "3" > "$zookeeper8_data_dir/myid"
    fi

echo "****"

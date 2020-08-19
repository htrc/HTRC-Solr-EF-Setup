#!/bin/bash

cmd=${1-status}

for hostname in solr3 solr4 solr5 ; do
    echo "****"
    echo "ssh $hostname sudo -u www-data  `which htrc-ef-zookeeper8-service-on-this-host.sh` $cmd "
    echo "****"
    ssh $hostname sudo -u www-data  `which htrc-ef-zookeeper8-service-on-this-host.sh` $cmd
    echo ""
done


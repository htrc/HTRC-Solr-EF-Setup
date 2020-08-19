#!/bin/bash

cmd=${1-status}

for hostname in solr3 solr4 solr5 solr6 peachpalm royalpalm ; do
    echo "****"
    echo "ssh $hostname sudo /bin/systemctl $cmd solrnodes8"
    echo "****"
    ssh $hostname sudo /bin/systemctl $cmd solrnodes8
    echo ""
done

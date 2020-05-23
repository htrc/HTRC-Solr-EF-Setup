#!/bin/bash

#if [ "x$SOLR8_TOP_LEVEL_HOME" = "x" ] ; then
#    echo "****" >&2
#    echo "* Environment variable SOLR8_TOP_LEVEL_HOME not set.  Have you sourced SETUP8.bash?" >&2    
#    echo "****" >&2
#    exit 1
#fi

#solr8_configsets="$SOLR8_TOP_LEVEL_HOME/server/solr/configsets"
solr8_configsets="solr8/server/solr/configsets"

echo "Copying conf/htrc_configs-docvals-841 in Solr8 configtests directory: $solr8_configsets"
/bin/cp -r conf/htrc-configs-docvals-841 "$solr8_configsets/htrc-configs-docvals"


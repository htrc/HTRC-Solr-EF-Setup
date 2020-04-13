#!/bin/bash

solr8_configsets="$SOLR8_TOP_LEVEL_HOME/server/solr/configsets"

echo "Copying conf/htrc_configs-docvals-841 in Solr8 configtests directory: $solr8_configsets"
/bin/cp -r conf/htrc-configs-docvals-841 "$solr8_configsets/htrc-configs-docvals"


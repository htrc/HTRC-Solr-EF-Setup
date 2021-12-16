
export SOLR8_TOP_LEVEL_HOME="$HTRC_EF_PACKAGE_HOME/solr8"

# In response to:
#   https://solr.apache.org/security.html#apache-solr-affected-by-apache-log4j-cve-2021-44228

## Explicitly specify directory where solr.in.sh is located
## which 'solr' sript will read in to set any environment variables
#export SOLR_INCLUDE="$SOLR7_TOP_LEVEL_HOME/bin"

# Currently favour the more direct route to setting this environment variable, as easier
# to roll out, once committed in github to repository

export SOLR_OPTS="$SOLR_OPTS -Dlog4j2.formatMsgNoLookups=true"


export SOLR8_HOME="$SOLR8_TOP_LEVEL_HOME/server/solr"
#export SOLR8_PID_DIR="$SOLR8_HOME"

#export PATH="$SOLR8_TOP_LEVEL_HOME/bin:$PATH"




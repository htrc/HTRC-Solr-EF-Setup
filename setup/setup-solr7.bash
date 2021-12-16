
export SOLR7_TOP_LEVEL_HOME="$HTRC_EF_PACKAGE_HOME/solr7"

# In response to:
#   https://solr.apache.org/security.html#apache-solr-affected-by-apache-log4j-cve-2021-44228

## Explicitly specify directory where solr.in.sh is located
## which 'solr' sript will read in to set any environment variables
#export SOLR_INCLUDE="$SOLR7_TOP_LEVEL_HOME/bin"

# Currently favour the more direct route to setting this environment variable, as easier
# to roll out, once committed in github to repository

export SOLR_OPTS="$SOLR_OPTS -Dlog4j2.formatMsgNoLookups=true"

export SOLR7_HOME="$SOLR_TOP_LEVEL_HOME/server/solr"
#export SOLR_PID_DIR="$SOLR_HOME"

#export PATH="$SOLR_TOP_LEVEL_HOME/bin:$PATH"




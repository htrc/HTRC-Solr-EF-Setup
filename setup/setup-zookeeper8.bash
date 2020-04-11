

export ZOOKEEPER8_HOME="$HTRC_EF_PACKAGE_HOME/zookeeper-for-solr8"
export ZOOCREEPER8_HOME="$HTRC_EF_PACKAGE_HOME/zoocreeper-master-for-solr8"

# htrc-ef-zookeeper-... scripts now run by specifying full-path rather than finding it via PATH
# Using full paths allows for more than one version of zookeeper to be installed on the filesystem

#export PATH="$ZOOKEEPER8_HOME/bin:$PATH"
#export PATH="$ZOOCREEPER8_HOME:$PATH"

if [ "$short_hostname" = "gsliscluster1" ] ; then
#  echo "* Added in Zookeeper Zoocreeper for Solr8 into PATH"
  echo "* Set ZOOKEEPER8_HOME for Solr8 to be: $ZOOKEEPER8_HOME"
  echo "* Set ZOOCREEPER8_HOME for Solr8 (for backup dumps) to be $ZOOCREEPER8_HOME"
fi



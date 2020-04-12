

export ZOOKEEPER_HOME="$HTRC_EF_PACKAGE_HOME/zookeeper"
export ZOOCREEPER_HOME="$HTRC_EF_PACKAGE_HOME/zoocreeper-master"

# htrc-ef-zookeeper-... scripts now run by specifying full-path rather than finding it via PATH
# Using full paths allows for more than one version of zookeeper to be installed on the filesystem

#export PATH="$ZOOKEEPER_HOME/bin:$PATH"
#export PATH="$ZOOCREEPER_HOME:$PATH"

if [ "$short_hostname" = "gsliscluster1" ] ; then
#  echo "* Added in Zookeeper and Zoocreeper into PATH"
  echo "* Set ZOOKEEPER_HOME to be: $ZOOKEEPER_HOME"
  echo "* Set ZOOCREEPER_HOME (for backup dumps) to be: $ZOOCREEPER_HOME"
fi



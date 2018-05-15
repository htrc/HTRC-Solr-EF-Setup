

export ZOOKEEPER_HOME="$HTRC_EF_PACKAGE_HOME/zookeeper"
export ZOOCREEPER_HOME="$HTRC_EF_PACKAGE_HOME/zoocreeper-master"

export PATH="$ZOOKEEPER_HOME/bin:$PATH"
export PATH="$ZOOCREEPER_HOME:$PATH"

if [ "$short_hostname" = "gsliscluster1" ] ; then
  echo "* Added in Zookeeper and Zoocreeper into PATH"
fi



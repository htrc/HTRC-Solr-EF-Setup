
store_cwd="`pwd`"
htrc_ef_home=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "$htrc_ef_home"

# 'short_hostname' used to control blocks of setup code run below:
#
#   gsliscluster1 and gc0, gc1, ... gc9 need to be setup for Spark + knowledge of Solr endpoint
#     if 'gsliscluster1' then also include echo statements to terminal to show what is being done
#
#   solr1 and solr2 need to be set up to run Solr cloud servers

# Using 'uname' looks to be more portable than 'hostname'
#  where minus arguments vary
#short_hostname=`hostname -s`
short_hostname=`uname -n | sed 's/\..*//'`

# ****
# The reason for controllilng a NETWORK_HOME, separate to
# a PACKAGE_HOME is no longer particularly strong, and
# the following can be simplified further
# ****
export HTRC_EF_NETWORK_HOME=`pwd`
export HTRC_EF_PACKAGE_HOME=`pwd`

case $- in
    *i*) # interactive
	if [ "$short_hostname" = "gsliscluster1" ] ; then
	    do_echo=1
	else
	    do_echo=0
	fi
	;;
    *) # otherwise non-interactive
	do_echo=0
	;;
esac

# Some (older) Java-based programs like to have JAVA_HOME set
# to operate smoothly.  Cover-off this aspect here
jdk_version=""
if [ "x$JAVA_HOME" = "x" ] ; then
    if [ -d "/usr/lib/jvm/java-11-openjdk-amd64" ] ; then
	export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
	jdk_version="1.11"
    else
	export JAVA_HOME="/usr/lib/jvm/j2sdk1.8-oracle"
	jdk_version="1.8"
    fi
fi

export PATH="$JAVA_HOME/bin:$PATH"
    
#export _JAVA_OPTIONS="-Xmx512m"
#export _JAVA_OPTIONS="-Xmx1024m"
#export _JAVA_OPTIONS="-Xmx2048m"
export _JAVA_OPTIONS=
#export _JAVA_OPTIONS="-XX:+HeapDumpOnOutOfMemoryError"

if [ $do_echo = 1 ] ; then    
    echo "* Added in JDK $jdk_version into PATH"
    echo "* set _JAVA_OPTIONS to the empty string"
fi

# Note: 'gchead' on Hadoop/Spark cluster stopped working at some point,
# so changed to specifying its IP value directly
#export SPARK_MASTER_HOST=gchead
export SPARK_MASTER_HOST=192.168.64.1

export SPARK_MASTER_URL=spark://$SPARK_MASTER_HOST:7077
export SPARK_SLAVE_HOSTS="gc0 gc1 gc2 gc3 gc4 gc5 gc6 gc7 gc8 gc9"

##
## Solr8 changes from here onwards
##

if [ "${short_hostname%[1-2]}" = "solr" ] ; then
    
  export ZOOKEEPER8_SERVER=solr1:9191

  export SOLR8_NODES="solr1:9983 solr1:9984 solr1:9985 solr1:9986 solr1:9987"
  export SOLR8_NODES="$SOLR8_NODES solr1:9988 solr1:9989 solr1:9990 solr1:9991 solr1:9992"
  export SOLR8_NODES="$SOLR8_NODES solr2:9983 solr2:9984 solr2:9985 solr2:9986 solr2:9987"
  export SOLR8_NODES="$SOLR8_NODES solr2:9988 solr2:9989 solr2:9990 solr2:9991 solr2:9992"

  export SOLR8_SHARDS="/disk0/solr8-full-ef /disk1/solr8-full-ef /disk2/solr8-full-ef /disk3/solr8-full-ef /disk4/solr8-full-ef"
  export SOLR8_SHARDS="$SOLR8_SHARDS /disk5/solr8-full-ef /disk6/solr8-full-ef /disk7/solr8-full-ef /disk8/solr8-full-ef /disk9/solr8-full-ef"
  export SOLR8_SHARDS="$SOLR8_SHARDS /disk0/solr8-full-ef /disk1/solr8-full-ef /disk2/solr8-full-ef /disk3/solr8-full-ef /disk4/solr8-full-ef"
  export SOLR8_SHARDS="$SOLR8_SHARDS /disk5/solr8-full-ef /disk6/solr8-full-ef /disk7/solr8-full-ef /disk8/solr8-full-ef /disk9/solr8-full-ef"

  export SOLR8_SERVER_BASE_JETTY_DIR=/disk0/solr8-jetty-servers
  if [ ! -d "$SOLR8_SERVER_BASE_JETTY_DIR" ] ; then
      mkdir "$SOLR8_SERVER_BASE_JETTY_DIR"
  fi
  #export SOLR_JAVA_MEM="-Xms10g -Xmx15g"
  # export SOLR_JAVA_MEM="-Xms5g -Xmx7g"
  export SOLR_JAVA_MEM="-Xmx14g"

elif [ "${short_hostname%[3-6]}" = "is-solr" ] || [ "${short_hostname}" = "is-peachpalm" ] || [ "${short_hostname}" = "is-royalpalm" ] ; then
  export ZOOKEEPER8_SERVER_ENSEMBLE=solr3:9191,solr4:9191,solr5:9191
  
  export SOLR8_NODES="solr3:9983 solr3:9984 solr3:9985 solr3:9986 solr3:9987 solr3:9988 solr3:9989 solr3:9990"
  export SOLR8_NODES="$SOLR8_NODES solr4:9983 solr4:9984 solr4:9985 solr4:9986 solr4:9987 solr4:9988 solr4:9989 solr4:9990"
  export SOLR8_NODES="$SOLR8_NODES solr5:9983 solr5:9984 solr5:9985 solr5:9986 solr5:9987 solr5:9988 solr5:9989 solr5:9990"
  export SOLR8_NODES="$SOLR8_NODES solr6:9983 solr6:9984 solr6:9985 solr6:9986 solr6:9987 solr6:9988 solr6:9989 solr6:9990"
  export SOLR8_NODES="$SOLR8_NODES peachpalm:9983 peachpalm:9984 peachpalm:9985 peachpalm:9986 peachpalm:9987 peachpalm:9988 peachpalm:9989 peachpalm:9990"
  export SOLR8_NODES="$SOLR8_NODES royalpalm:9983 royalpalm:9984 royalpalm:9985 royalpalm:9986 royalpalm:9987 royalpalm:9988 royalpalm:9989 royalpalm:9990"

  root_solr8_shard_dir=htrc-ef-solr8-shards
  # solr3
  export SOLR8_SHARDS="/disk1/$root_solr8_shard_dir /disk2/$root_solr8_shard_dir /disk3/$root_solr8_shard_dir /disk4/$root_solr8_shard_dir"
  export SOLR8_SHARDS="$SOLR8_SHARDS /disk5/$root_solr8_shard_dir /disk6/$root_solr8_shard_dir /disk7/$root_solr8_shard_dir /disk8/$root_solr8_shard_dir"
  # solr4  
  export SOLR8_SHARDS="$SOLR8_SHARDS /disk1/$root_solr8_shard_dir /disk2/$root_solr8_shard_dir /disk3/$root_solr8_shard_dir /disk4/$root_solr8_shard_dir"
  export SOLR8_SHARDS="$SOLR8_SHARDS /disk5/$root_solr8_shard_dir /disk6/$root_solr8_shard_dir /disk7/$root_solr8_shard_dir /disk8/$root_solr8_shard_dir"
  # solr5
  export SOLR8_SHARDS="$SOLR8_SHARDS /disk1/$root_solr8_shard_dir /disk2/$root_solr8_shard_dir /disk3/$root_solr8_shard_dir /disk4/$root_solr8_shard_dir"
  export SOLR8_SHARDS="$SOLR8_SHARDS /disk5/$root_solr8_shard_dir /disk6/$root_solr8_shard_dir /disk7/$root_solr8_shard_dir /disk8/$root_solr8_shard_dir"
  # solr6  
  export SOLR8_SHARDS="$SOLR8_SHARDS /disk1/$root_solr8_shard_dir /disk2/$root_solr8_shard_dir /disk3/$root_solr8_shard_dir /disk4/$root_solr8_shard_dir"
  export SOLR8_SHARDS="$SOLR8_SHARDS /disk5/$root_solr8_shard_dir /disk6/$root_solr8_shard_dir /disk7/$root_solr8_shard_dir /disk8/$root_solr8_shard_dir"
  # solr7/peachpalm
  export SOLR8_SHARDS="$SOLR8_SHARDS /solr-data/node1/$root_solr8_shard_dir /solr-data/node2/$root_solr8_shard_dir /solr-data/node3/$root_solr8_shard_dir /solr-data/node4/$root_solr8_shard_dir"
  export SOLR8_SHARDS="$SOLR8_SHARDS /solr-data/node5/$root_solr8_shard_dir /solr-data/node6/$root_solr8_shard_dir /solr-data/node7/$root_solr8_shard_dir /solr-data/node8/$root_solr8_shard_dir"
  # solr8/royalalm
  export SOLR8_SHARDS="$SOLR8_SHARDS /solr-data/node1/$root_solr8_shard_dir /solr-data/node2/$root_solr8_shard_dir /solr-data/node3/$root_solr8_shard_dir /solr-data/node4/$root_solr8_shard_dir"
  export SOLR8_SHARDS="$SOLR8_SHARDS /solr-data/node5/$root_solr8_shard_dir /solr-data/node6/$root_solr8_shard_dir /solr-data/node7/$root_solr8_shard_dir /solr-data/node8/$root_solr8_shard_dir"

  
  # Consider making this /opt/ ????
  export SOLR8_SERVER_BASE_JETTY_DIR=/usr/local/solr8-jetty-servers
  
  # 14g used for the solr1 + solr2 config
  # solr3-6 config uses less shards per box, so bump up the value slightly
  # Note: JRE performance will drop off if value goes about 32G as JRE needs
  #       to switch from using compressed pointers to long pointers
  #       -- see: https://lucene.apache.org/solr/guide/7_4/taking-solr-to-production.html
  export SOLR_JAVA_MEM="-Xmx20g"

  # tail of previous vals used over time (from most recent to oldest)
  # export SOLR_JAVA_MEM="-Xmx14g"
  # export SOLR_JAVA_MEM="-Xms5g -Xmx7g"
  # export SOLR_JAVA_MEM="-Xms10g -Xmx15g"

elif [ "$short_hostname" = "immensity" ] ; then
  export ZOOKEEPER8_SERVER=localhost:9191

  export SOLR8_NODES="localhost:9983 localhost:9984 "
  export SOLR8_SHARDS="/tmp/solr8-full-ef-node1 /tmp/solr8-full-ef-node2"

  export SOLR8_SERVER_BASE_JETTY_DIR=/tmp/solr8-jetty-servers
fi

if [ -d "$HTRC_EF_NETWORK_HOME/HTRC-Solr-EF-Ingester/" ] ; then
    # e.g., gsliscluster1 or gc[0-9]

## ## ##
    ## Most likely the following is no longer used by the ingester, but rather goes off what the solr-enpoint
    ## is defined to be in the Java properties files read in
    
#    export SOLR8_NODES="solr1-s:9983 solr1-s:9984 solr1-s:9985 solr1-s:9986 solr1-s:9987"
#    export SOLR8_NODES="$SOLR8_NODES solr1-s:9988 solr1-s:9989 solr1-s:9990 solr1-s:9991 solr1-s:9992"
#    export SOLR8_NODES="$SOLR8_NODES solr2-s:9983 solr2-s:9984 solr2-s:9985 solr2-s:9986 solr2-s:9987"
#    export SOLR8_NODES="$SOLR8_NODES solr2-s:9988 solr2-s:9989 solr2-s:9990 solr2-s:9991 solr2-s:9992"

## ## ##
    # But this would still be used ... watch out incase 'gchead' not resolving correctly    
    export HDFS_HEAD=hdfs://gchead:9000
    export YARN_CONF_DIR=/etc/hadoop/conf
fi



if [ $do_echo = 1 ] ; then
  echo ""
  echo "****"
fi

if [ -d "$HTRC_EF_NETWORK_HOME/HTRC-Solr-EF-Ingester/" ] ; then
    source setup/setup-spark.bash

    export PATH="$HTRC_EF_NETWORK_HOME/HTRC-Solr-EF-Ingester/scripts:$PATH"
    if [ $do_echo = 1 ] ; then        
      echo "* Added in HTRC-Solr-EF-Ingester scripting into PATH"
    fi

    if [ -d "$SPARK_HOME/" ] ; then
	spark_conf_defaults="$SPARK_HOME/conf/spark-defaults.conf" 
	if [ ! -f "$spark_conf_defaults" ] ; then
	    echo "* Copying conf/spark-defaults.conf -> $spark_conf_defaults"
	    /bin/cp conf/spark-defaults.conf "$spark_conf_defaults"
	fi

	spark_conf_slaves="$SPARK_HOME/conf/slaves" 
	if [ ! -f "$spark_conf_slaves" ] ; then
	    echo "****"
	    echo "* Populating $spark_conf_slaves" 
	    echo "* With: $SPARK_SLAVE_HOSTS"
	    echo "****"
	    for s in $SPARK_SLAVE_HOSTS ; do
		echo $s >> "$spark_conf_slaves"
	    done	    
	else
	    slaves=`cat "$spark_conf_slaves" | tr '\n' ' '`
	    if [ $do_echo = 1 ] ; then        
		echo "****"
		echo "* Spark slaves: $slaves"
		echo "****"
	    fi
	fi
    fi
fi

if [ -d "$HTRC_EF_NETWORK_HOME/HTRC-Solr-EF-Cloud/" ] ; then
  source setup/setup-zookeeper8.bash 
  source setup/setup-solr8.bash

  export PATH="$HTRC_EF_NETWORK_HOME/HTRC-Solr-EF-Cloud/scripts:$PATH"
    if [ $do_echo = 1 ] ; then        
      echo "* Added in HTRC-Solr-EF-Cloud scripting into PATH"
  fi
fi


cd "$store_cwd"

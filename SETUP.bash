
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

if [ "x$JAVA_HOME" = "x" ] ; then    
    export JAVA_HOME="/usr/lib/jvm/j2sdk1.8-oracle"
fi

export PATH="$JAVA_HOME/bin:$PATH"
    
#export _JAVA_OPTIONS="-Xmx512m"
#export _JAVA_OPTIONS="-Xmx1024m"
#export _JAVA_OPTIONS="-Xmx2048m"
export _JAVA_OPTIONS=
#export _JAVA_OPTIONS="-XX:+HeapDumpOnOutOfMemoryError"

if [ $do_echo = 1 ] ; then    
    echo "* Added in JDK 1.8 into PATH"
    echo "* set _JAVA_OPTIONS to the empty string"
fi

# Note: 'gchead' stopped working at some point, so changed to specifying its IP value 
#export SPARK_MASTER_HOST=gchead
export SPARK_MASTER_HOST=192.168.64.1

export SPARK_MASTER_URL=spark://$SPARK_MASTER_HOST:7077
export SPARK_SLAVE_HOSTS="gc0 gc1 gc2 gc3 gc4 gc5 gc6 gc7 gc8 gc9"

if [ "${short_hostname%[1-2]}" = "solr" ] ; then
  export ZOOKEEPER_SERVER=solr1:8181

  export SOLR_NODES="solr1:8983 solr1:8984 solr1:8985 solr1:8986 solr1:8987"
  export SOLR_NODES="$SOLR_NODES solr1:8988 solr1:8989 solr1:8990 solr1:8991 solr1:8992"
  export SOLR_NODES="$SOLR_NODES solr2:8983 solr2:8984 solr2:8985 solr2:8986 solr2:8987"
  export SOLR_NODES="$SOLR_NODES solr2:8988 solr2:8989 solr2:8990 solr2:8991 solr2:8992"

  export SOLR_SHARDS="/disk0/solr-full-ef /disk1/solr-full-ef /disk2/solr-full-ef /disk3/solr-full-ef /disk4/solr-full-ef"
  export SOLR_SHARDS="$SOLR_SHARDS /disk5/solr-full-ef /disk6/solr-full-ef /disk7/solr-full-ef /disk8/solr-full-ef /disk9/solr-full-ef"
  export SOLR_SHARDS="$SOLR_SHARDS /disk0/solr-full-ef /disk1/solr-full-ef /disk2/solr-full-ef /disk3/solr-full-ef /disk4/solr-full-ef"
  export SOLR_SHARDS="$SOLR_SHARDS /disk5/solr-full-ef /disk6/solr-full-ef /disk7/solr-full-ef /disk8/solr-full-ef /disk9/solr-full-ef"

  export SOLR_SERVER_BASE_JETTY_DIR=/disk0
  
  #export SOLR_JAVA_MEM="-Xms10g -Xmx15g"
  # export SOLR_JAVA_MEM="-Xms5g -Xmx7g"
  export SOLR_JAVA_MEM="-Xmx14g"
elif [ "$short_hostname" = "immensity" ] ; then
  export ZOOKEEPER_SERVER=localhost:8181

  export SOLR_NODES="localhost:8983 localhost:8984 "
  export SOLR_SHARDS="/tmp/solr-full-ef-node1 /tmp/solr-full-ef-node2"

  export SOLR_SERVER_BASE_JETTY_DIR=/tmp
fi

if [ "${short_hostname%[0-9]}" = "gc" ] ; then
  ## export HTRC_EF_PACKAGE_HOME="/hdfsd05/dbbridge/gslis-cluster"
  #export HTRC_EF_PACKAGE_HOME="/hdfsd05/dbbridge/HTRC-Solr-EF-Setup"
  #export HTRC_EF_PACKAGE_HOME="/data0/dbbridge/gslis-cluster"
  export HTRC_EF_PACKAGE_HOME=`pwd`
else
  export HTRC_EF_PACKAGE_HOME=`pwd`
fi

export HTRC_EF_NETWORK_HOME=`pwd`

if [ -d "$HTRC_EF_NETWORK_HOME/HTRC-Solr-EF-Ingester/" ] ; then
    # e.g., gslis-cluster1 or gc[0-9]
    
#    export SOLR_NODES="solr1-s:8983 solr1-s:8984 solr1-s:8985 solr1-s:8986 solr1-s:8987"
#    export SOLR_NODES="$SOLR_NODES solr1-s:8988 solr1-s:8989 solr1-s:8990 solr1-s:8991 solr1-s:8992"
#    export SOLR_NODES="$SOLR_NODES solr2-s:8983 solr2-s:8984 solr2-s:8985 solr2-s:8986 solr2-s:8987"
#    export SOLR_NODES="$SOLR_NODES solr2-s:8988 solr2-s:8989 solr2-s:8990 solr2-s:8991 solr2-s:8992"

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
  source setup/setup-zookeeper.bash 
  source setup/setup-solr7.bash

  export PATH="$HTRC_EF_NETWORK_HOME/HTRC-Solr-EF-Cloud/scripts:$PATH"
    if [ $do_echo = 1 ] ; then        
      echo "* Added in HTRC-Solr-EF-Cloud scripting into PATH"
  fi
fi


if [ "x$ZOOKEEPER_HOME" != "x" ] ; then
  zookeeper_config_file="$ZOOKEEPER_HOME/conf/zoo.cfg"
  zookeeper_data_dir="$ZOOKEEPER_HOME/data"

  if [ ! -f "$zookeeper_config_file" ] ; then
    echo "****"
    echo "* Generating $zookeeper_config_file" 
    cat conf/zoo.cfg.in | sed "s%@zookeeper-data-dir@%$zookeeper_data_dir%g" > "$zookeeper_config_file"

    if [ ! -d "$zookeeper_data_dir" ] ; then
	echo "* Creating Zookeeper dataDir:"
	echo "*   $zookeeper_data_dir"
	mkdir "$zookeeper_data_dir"
    fi
    echo "****"
  fi
fi

if [ $do_echo = 1 ] ; then        
  echo "****"
  echo "* Solr nodes: $SOLR_NODES"
  echo "****"
fi

if [ -d "$HTRC_EF_NETWORK_HOME/HTRC-Solr-EF-Cloud/" ] ; then
	
  solr_configsets="$SOLR_TOP_LEVEL_HOME/server/solr/configsets"
  if [ ! -d "$solr_configsets/htrc_configs" ] ; then
    echo "Untarring htrc_configs.tar.gz in Solr configtests directory"
    tar xvzf conf/htrc_configs.tar.gz -C "$solr_configsets"
  fi
fi

cd "$store_cwd"


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
# The reason for controllilng a NETWOR_HOME, separate to
# a PACKAGE_HOME is no longer particularly strong, and
# the following can be simplified further

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

elif [ "${short_hostname%[3-6]}" = "is-solr" ] ; then
  export ZOOKEEPER_SERVER=solr3:8181

  export SOLR_PID_DIR="$HTRC_EF_PACKAGE_HOME/solr-jetty-pids"
  if [ ! -d "$SOLR_PID_DIR" ] ; then
      mkdir "$SOLR_PID_DIR"
  fi
  
  export SOLR_NODES="solr3:8983 solr3:8984 solr3:8985 solr3:8986 solr3:8987 solr3:8988 solr3:8989 solr3:8990"
  export SOLR_NODES="$SOLR_NODES solr4:8983 solr4:8984 solr4:8985 solr4:8986 solr4:8987 solr4:8988 solr4:8989 solr4:8990"
  export SOLR_NODES="$SOLR_NODES solr5:8983 solr5:8984 solr5:8985 solr5:8986 solr5:8987 solr5:8988 solr5:8989 solr5:8990"
  export SOLR_NODES="$SOLR_NODES solr6:8983 solr6:8984 solr6:8985 solr6:8986 solr6:8987 solr6:8988 solr6:8989 solr6:8990"

  root_solr_shard_dir=htrc-ef-solr-shards
  # solr3
  export SOLR_SHARDS="/disk1/$root_solr_shard_dir /disk2/$root_solr_shard_dir /disk3/$root_solr_shard_dir /disk4/$root_solr_shard_dir"
  export SOLR_SHARDS="$SOLR_SHARDS /disk5/$root_solr_shard_dir /disk6/$root_solr_shard_dir /disk7/$root_solr_shard_dir /disk8/$root_solr_shard_dir"
  # solr4  
  export SOLR_SHARDS="$SOLR_SHARDS /disk1/$root_solr_shard_dir /disk2/$root_solr_shard_dir /disk3/$root_solr_shard_dir /disk4/$root_solr_shard_dir"
  export SOLR_SHARDS="$SOLR_SHARDS /disk5/$root_solr_shard_dir /disk6/$root_solr_shard_dir /disk7/$root_solr_shard_dir /disk8/$root_solr_shard_dir"
  # solr5
  export SOLR_SHARDS="$SOLR_SHARDS /disk1/$root_solr_shard_dir /disk2/$root_solr_shard_dir /disk3/$root_solr_shard_dir /disk4/$root_solr_shard_dir"
  export SOLR_SHARDS="$SOLR_SHARDS /disk5/$root_solr_shard_dir /disk6/$root_solr_shard_dir /disk7/$root_solr_shard_dir /disk8/$root_solr_shard_dir"
  # solr6  
  export SOLR_SHARDS="$SOLR_SHARDS /disk1/$root_solr_shard_dir /disk2/$root_solr_shard_dir /disk3/$root_solr_shard_dir /disk4/$root_solr_shard_dir"
  export SOLR_SHARDS="$SOLR_SHARDS /disk5/$root_solr_shard_dir /disk6/$root_solr_shard_dir /disk7/$root_solr_shard_dir /disk8/$root_solr_shard_dir"

  # consider making this /opt/ ????
  #export SOLR_SERVER_BASE_JETTY_DIR=/disk1
  export SOLR_SERVER_BASE_JETTY_DIR=/usr/local/htrc-ef-jetty-servers
  
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
  export ZOOKEEPER_SERVER=localhost:8181

  export SOLR_NODES="localhost:8983 localhost:8984 "
  export SOLR_SHARDS="/tmp/solr-full-ef-node1 /tmp/solr-full-ef-node2"

  export SOLR_SERVER_BASE_JETTY_DIR=/tmp
fi

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
  zookeeper_port=${ZOOKEEPER_SERVER##*:}
  
  if [ ! -f "$zookeeper_config_file" ] ; then
    if [ ! -d "$zookeeper_data_dir" ] ; then
	echo "* Creating Zookeeper dataDir:"
	echo "*   $zookeeper_data_dir"
	mkdir "$zookeeper_data_dir"
    fi
      
    echo "****"
    echo "* Generating $zookeeper_config_file"
    if [ "${short_hostname%[3-6]}" = "is-solr" ] ; then
	cat conf/zoo-ensemble.cfg.in \
	    | sed "s%@zookeeper-data-dir@%$zookeeper_data_dir%g" \
	    | sed "s%@zookeeper-port@%$zookeeper_port%g" \		  
	    > "$zookeeper_config_file"

	echo "***!!!!!!!!"
	echo "*** Warning: There are hard-wired Zookeeper port numbers for solr3,solr4,solr5 in conf/zoo-ensemble.cfg.in"
	echo "***!!!!!!!!"
	
	if [ "$short_hostname" = "is-solr3" ] ; then
	    echo "1" > "$zookeeper_data_dir/myid"
	fi
	if [ "$short_hostname" = "is-solr4" ] ; then
	    echo "2" > "$zookeeper_data_dir/myid"
	fi
	if [ "$short_hostname" = "is-solr5" ] ; then
	    echo "3" > "$zookeeper_data_dir/myid"
	fi
    else
	cat conf/zoo.cfg.in \
	    | sed "s%@zookeeper-data-dir@%$zookeeper_data_dir%g" \
	    | sed "s%@zookeeper-port@%$zookeeper_port%g" \		  
	    > "$zookeeper_config_file"
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
	
  solr_configsets="$SOLR7_TOP_LEVEL_HOME/server/solr/configsets"
  if [ ! -d "$solr_configsets/htrc_configs" ] ; then
    echo "Untarring htrc_configs.tar.gz in Solr configtests directory"
    tar xvzf conf/htrc_configs.tar.gz -C "$solr_configsets"
  fi
fi

cd "$store_cwd"

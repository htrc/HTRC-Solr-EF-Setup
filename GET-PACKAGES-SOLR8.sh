#!/bin/bash

get_zookeeper="y"
#zookeeper_ver=3.4.9
#zookeeper_ver=3.4.13
zookeeper_ver=3.5.7

get_solr="y"
#solr_ver=7.2.1
#solr_ver=7.4.0
solr_ver=8.4.1

if [ $get_zookeeper = "y" ] ; then
    echo "***"
    echo "Zookeeper $zookeeper_ver"
    echo "***"
    /bin/rm -f zookeeper-$zookeeper_ver.tar.gz zookeeper-for-solr8
    wget http://archive.apache.org/dist/zookeeper/zookeeper-$zookeeper_ver/apache-zookeeper-$zookeeper_ver.tar.gz \
	&& tar xvzf apache-zookeeper-$zookeeper_ver.tar.gz \
	&& ln -s apache-zookeeper-$zookeeper_ver zookeeper-for-solr8 \
	&& echo && echo "Created symbolic link 'zookeeper-for-solr8'"
    echo "***"
    echo ""
fi

if [ $get_solr = "y" ] ; then
    
    echo ""
    echo "***"
    echo "Solr $solr_ver"
    echo "***"
    echo ""
    /bin/rm -f solr-$solr_ver.tgz solr8
#    wget http://archive.apache.org/dist/lucene/solr/$solr_ver/solr-$solr_ver.tgz \
     wget http://www.apache.org/dist/lucene/solr/$solr_ver/solr-$solr_ver.tgz \
	&& tar xvzf solr-$solr_ver.tgz \
	&& ln -s solr-$solr_ver solr8 \
	&& echo && echo "Created symbolic link 'solr8'"
    
    echo "***"
    echo ""
fi

if [ ! -d zookeeper-master ] ; then
  echo ""
  echo "***"
  echo "Now run:"
  echo "  ./GET-PACKAGES-ZOOCREEPER.sh"
  echo "This will enable you to take backup snapshots of the Zookeeper files"
  echo "***"
  echo ""
fi

echo "To see what editing for jetty.xml and web.xml is needed, run:"
echo "  ./PREP-SOLR8-JETTY.sh"
echo "To see the 'diff' as to what needs to be added"
echo ""
echo "To then top-up the Jetty files within the downloaded Solr8 directory, run:"
echo "  ./TOPUP-SOLR8-JETTY.sh"
echo ""


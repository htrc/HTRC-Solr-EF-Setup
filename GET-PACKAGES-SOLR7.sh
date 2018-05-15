#!/bin/bash

get_zookeeper="y"
zookeeper_ver=3.4.9

get_solr="y"
solr_ver=7.2.1

if [ $get_zookeeper = "y" ] ; then
    echo "***"
    echo "Zookeeper $zookeeper_ver"
    echo "***"
    /bin/rm -f zookeeper-$zookeeper_ver.tar.gz zookeeper
    wget http://archive.apache.org/dist/zookeeper/zookeeper-$zookeeper_ver/zookeeper-$zookeeper_ver.tar.gz \
	&& tar xvzf zookeeper-$zookeeper_ver.tar.gz \
	&& ln -s zookeeper-$zookeeper_ver zookeeper \
	&& echo && echo "Created symbolic link 'zookeeper'"
    echo "***"
    echo ""
fi

if [ $get_solr = "y" ] ; then
    
    echo ""
    echo "***"
    echo "Solr $solr_ver"
    echo "Note: There is a newer version out (7.3 released April 2018)"
    echo " => consider upgrading?"
    echo "***"
    echo ""
    /bin/rm -f solr-$solr_ver.tgz solr7
    wget http://archive.apache.org/dist/lucene/solr/$solr_ver/solr-$solr_ver.tgz \
	&& tar xvzf solr-$solr_ver.tgz \
	&& ln -s solr-$solr_ver solr7 \
	&& echo && echo "Created symbolic link 'solr7'"
    
    echo "***"
    echo ""
fi

echo ""
echo "***"
echo "Now run ./GET-PACKAGES-ZOOCREEPER.sh (if not alrady done so)"
echo "  This will enable you to take backup snapshots of the Zookeeper files"
echo "***"
echo ""

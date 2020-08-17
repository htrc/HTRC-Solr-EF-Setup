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
    wget http://archive.apache.org/dist/zookeeper/zookeeper-$zookeeper_ver/apache-zookeeper-$zookeeper_ver-bin.tar.gz \
	&& tar xvzf apache-zookeeper-$zookeeper_ver-bin.tar.gz \
	&& ln -s apache-zookeeper-$zookeeper_ver-bin zookeeper-for-solr8 \
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
#     wget http://www.apache.org/dist/lucene/solr/$solr_ver/solr-$solr_ver.tgz \
    wget http://archive.apache.org/dist/lucene/solr/$solr_ver/solr-$solr_ver.tgz \
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
  echo "  /bin/mv zoocreeper-master zoocreeper-master-for-solr8"
#  echo "  ./GET-PACKAGES-ZOOCREEPER8.sh"
  echo "This will enable you to take backup snapshots of the Zookeeper files"
  echo "***"
  echo ""
fi

echo "===="
echo "Sidebar: To see what manual editing for jetty.xml and web.xml is needed, run:"
echo "  ./PREP-SOLR8-JETTY.sh"
echo "This 'diffs' what the *default* *Solr7* conf files with the versions of those"
echo "files that were manually edited for HTRC-Ef use."
echo "These details are useful when breaking in a new major upgrade version of Solr"
echo "===="
echo ""
echo "Assuming these changes have already been spliced into the Solr8 version of the"
echo "config files in ./conf/jetty-solr8/, then it is only necessary to run the following"
echo "commands to trasfer the modified config files into the Jetty area within the "
echo "downloaded Solr8 directory:"
echo "  ./SOLR8-JETTY-SET-PASSWORD.sh"
echo "  ./SOLR8-JETTY-TOPUP.sh"
echo ""
echo "To add in the custom Solr Schema used by HTRC-EF run:"
echo "  ./SOLR8-TOPUP-CONFIGSETS.sh"
echo ""


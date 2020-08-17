#!/bin/bash

get_maven="y"
maven_ver=3.5.3

if [ $get_maven = "y" ] ; then
    echo "***"
    echo "Apache Maven $maven_ver"
    echo "***"
    /bin/rm -f apache-maven-$maven_ver-bin.tar.gz maven
    wget http://archive.apache.org/dist/maven/maven-3/3.5.3/binaries/apache-maven-$maven_ver-bin.tar.gz \
	&& tar xvzf apache-maven-$maven_ver-bin.tar.gz \
	&& ln -s apache-maven-$maven_ver maven \
	&& echo && echo "Created symbolic link 'maven'"
    echo "***"
    echo ""
fi

if [ -d "`pwd`/maven/" ] ; then
    export PATH="`pwd`/maven/bin":$PATH
    echo "Added maven to PATH"
fi

/bin/rm zoocreeper-master.zip
wget https://github.com/boundary/zoocreeper/archive/master.zip -O zoocreeper-master.zip \
    && unzip zoocreeper-master.zip \
    && cd zoocreeper-master \
    && mvn clean package

echo ""
echo "To set up a Zoocreeper for Solr8, run the following:"
echo "  /bin/mv zoocreeper-master zoocreeper-master-for-solr8"
echo "Or to allow Zoocreeper to operate for solr7 and solr8 installs in parallel"
echo "  /bin/cp -r zoocreeper-master zoocreeper-master-for-solr8"
echo ""




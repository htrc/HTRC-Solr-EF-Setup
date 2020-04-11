#!/bin/bash

# Setup jetty servers so it is cross-origin for AJAX call
# Useful URL:
#    http://opensourceconnections.com/blog/2015/03/26/going-cross-origin-with-solr/

# Also add in realm authentication for admin area

echo ""
echo "Need conf/jetty-solr8/ files that allow cross-origin settings and realm authentication"
echo ""

if [ ! -d conf/jetty-solr8/ ] ; then
    echo "Creating directory 'conf/jetty-solr8'"
    mkdir conf/jetty-solr8
fi

if [ ! -f conf/jetty-solr8/jetty.xml.orig ] ; then
    echo "Populating 'conf/jetty-solr8/' with jetty.xml.orig"
    /bin/cp solr8/server/etc/jetty.xml conf/jetty-solr8/jetty.xml.orig
    /bin/cp solr8/server/etc/jetty.xml conf/jetty-solr8/jetty.xml
fi


if [ ! -f conf/jetty-solr8/web.xml.orig ] ; then
    echo "Populating 'conf/jetty-solr8/' with web.xml.orig"
    /bin/cp solr8/server/solr-webapp/webapp/WEB-INF/web.xml conf/jetty-solr8/web.xml.orig
    /bin/cp solr8/server/solr-webapp/webapp/WEB-INF/web.xml conf/jetty-solr8/web.xml
fi

if [ ! -f conf/jetty-solr8/realm.properties ] ; then
    echo "Populating 'conf/jetty-solr8/' with realm.properites"
    echo cp conf/jetty-solr7/realm.properties conf/jetty-solr8/realm.properties
    cp conf/jetty-solr7/realm.properties conf/jetty-solr8/realm.properties 
fi

echo diff conf/jetty-solr7/jetty.xml.orig conf/jetty-solr7/jetty.xml
diff conf/jetty-solr7/jetty.xml.orig conf/jetty-solr7/jetty.xml 
echo "-----"
echo "The addBean element can be added at the very bottom of the file"
echo "-----"

echo diff conf/jetty-solr7/web.xml.orig conf/jetty-solr7/web.xml
diff conf/jetty-solr7/web.xml.orig conf/jetty-solr7/web.xml 

echo "-----"
echo "The cross-origin block can be placed at the top of the file"
echo "The security-contraint block can be placed at the bottom of the file"
echo "-----"

echo ""

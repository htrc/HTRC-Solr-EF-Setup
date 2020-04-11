#!/bin/bash

# Setup jetty servers so it is cross-origin for AJAX call
# Useful URL:
#    http://opensourceconnections.com/blog/2015/03/26/going-cross-origin-with-solr/

# Also add in realm authentication for admin area

echo ""
echo "Adding in cross-origin settings and realm authentication to Jetty config files"
echo ""

echo cp conf/jetty-solr8/web.xml solr8/server/solr-webapp/webapp/WEB-INF/web.xml
cp conf/jetty-solr8/web.xml solr8/server/solr-webapp/webapp/WEB-INF/web.xml

echo cp conf/jetty-solr8/jetty.xml solr8/server/etc/jetty.xml
cp conf/jetty-solr8/jetty.xml solr8/server/etc/jetty.xml

echo cp conf/jetty-solr8/realm.properties solr8/server/etc/realm.properties
cp conf/jetty-solr8/realm.properties solr8/server/etc/realm.properties
echo ""

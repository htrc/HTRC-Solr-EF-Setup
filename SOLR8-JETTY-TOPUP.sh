#!/bin/bash

# Setup jetty servers so it is cross-origin for AJAX call
# Useful URL:
#    http://opensourceconnections.com/blog/2015/03/26/going-cross-origin-with-solr/

# Also add in realm authentication for admin area
#
# Should probably consider changing from Basic Realm authentication through
# servlet, to being based on:
#   https://lucene.apache.org/solr/guide/8_4/basic-authentication-plugin.html
# As Basic Realm does not integrate well with Solr Admin UI interface (Solr 8.4.1)
#
# Even after logging in to the Admin UI, creating a collection then fails
# Inspecting the solr.log shows errors assocated with failure to authenticated
# sub-actions that run.
# => Workaround is to open up those sub-actions:
#      /admin/metrics and /admin/cores
#    in web.xml file


if [ ! -f conf/jetty-solr8/realm.properties ] ; then
    echo "****" >&2
    echo "* Failed to detect:" >&2
    echo "*   conf/jetty-solr8/realm.properties" >&2
    echo "* This means no password has been set yet for the Solr/Jetty Admin UI" >&2
    echo "* This can be done by running:" >&2
    echo "*   ./SOLR8-JETTY-SET-PASSWORD.sh" >&2
    echo "****" >&2
    exit -1
fi

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

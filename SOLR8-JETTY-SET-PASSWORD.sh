#!/bin/bash

if [ -f conf/jetty-solr8/realm.properties ] ; then
    echo "****" >&2
    echo "* Realm property file already exists: " >&2
    echo "*  conf/jetty-solr8/realm.properties" >&2
    echo "* To regenerate the Solr/Jetty Admin UI password, remove this file then run script again" >&2
    echo "****" >&2
    exit -1
fi

echo "Enter password for 'admin' (password text will appear on screen):"
read solr_admin_password


echo "Generating conf/jetty-solr8/realm.properties from conf/jetty-solr8/realm.properties.in"

				      
cat conf/jetty-solr8/realm.properties.in \
    | sed "s%@solr8-admin-username@%admin%g" \
    | sed "s%@solr8-admin-password@%$solr_admin_password%g" \
    > conf/jetty-solr8/realm.properties

echo ""
echo "Next run:"
echo "  ./SOLR8-JETTY-TOPUP.sh"
echo "To transfer the Solr Admin UI password and other HTRC-EF specific"
echo "custom settings to '$SOLR8_TOP_LEVEL_HOME'"
echo ""

if [ "x$SOLR8_TOP_LEVEL_HOME" = "x" ] ; then
    echo "Error: environment variable SOLR8_TOP_LEVEL_HOME not set.  Have you sourced SETUP8.bash?" >&2
    echo "Have you added . `pwd`/SETUP8.bash to your ~/.bashrc file?" >&2
fi


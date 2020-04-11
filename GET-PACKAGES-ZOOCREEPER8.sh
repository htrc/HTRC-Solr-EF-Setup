#!/bin/bash


if [ ! -d zoocreeper-master-for-solr8 ] ; then
  echo "***"
  echo "* Copying zoocreeper-master -> zoocreeper-master-for-solr8"
  echo "***"

  /bin/cp -r zoocreeper-master zoocreeper-master-for-solr8
else
  echo "***"
  echo "* The directory 'zoocreeper-master-for-solr8' already exists"
  echo "***"
fi




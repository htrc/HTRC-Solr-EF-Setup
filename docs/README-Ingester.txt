Preamble
========

There are two main components to the code that supports the searching
of the Extracted Features JSON files:
   (i) Ingesting the EF JSON files using Spark
  (ii) Running a Solr Cloud installation with the resulting index

The code is designed so (i) and (ii) can be on separate computers
or on the same computer.  This is done by having a top-level 'Setup'
project that is shared between the two components.  Within
this shared 'Setup' directory you then check out either
(i) or (ii) or both.

This README file covers Component (i) the Indexer.


Installation
============

To check out the code needed to ingest the Extracted Features JSON
files into Solr using a Spark cluster, do the following:

  git clone https://github.com/htrc/HTRC-Solr-EF-Setup
  cd HTRC-Solr-EF-Setup/
  git clone https://github.com/htrc/HTRC-Solr-EF-Ingester
  ./GET-PACKAGES-SPARK.sh
  
In the instruction below this has been done in the /data0/ directory.
Modify the relevant statements according if installing in a different
directory.

Once everything is setup, the usual directory to be in when running
commands is:
  /data0/HTRC-Solr-EF-Setup/HTRC-Solr-EF-Ingester


Setup
=====

To setup your environment to run this code, edit your ~/.bashrc file to include:

  store_cwd="`pwd`"
  cd /data0/HTRC-Solr-EF-Setup && source ./SETUP.bash && cd "$store_cwd"

The values in SETUP.bash assume:

  1. You are on 'gsliscluster1' which has Hadoop 2.6 installed
     (the Spark code make use of HDFS and Yarn that comes with this).
  2. The ingested JSON files are streamed over to a cloud configuration
     of Solr set up on 'solr1' and 'solr2'
  3. You have setup ssh so you can log into the nodes in the Hadoop/Spark
     cluster (gc1, gc2, etc) without needing to enter your password

If you do not have JAVA_HOME explictly set, it will default to:
   /usr/lib/jvm/j2sdk1.8-oracle

Finally, ensure your can ssh in to machines (solr1 solr2) from solr1 without password


Compilation
===========

The Java code for reading in the Solr Extracted Feature files,
transforming the data into the Solr JSON format, and then streaming
it to a Solr installation needs to be compiled.  This can be done with:

  ./COMPILE.sh




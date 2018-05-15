
This directory was set up through the following commands:

  git clone https://github.com/htrc/HTRC-Solr-EF-Setup
  cd HTRC-Solr-EF-Setup/
  git clone https://github.com/htrc/HTRC-Solr-EF-Ingester
./GET-PACKAGES-SPARK.sh

This checks out the code needed to ingest the Extracted Features JSON
files into Solr using a Spark cluster.

To add this to your environment, edit your ~/.bashrc file to include:

  cd /data0/HTRC-Solr-EF-Setup && source ./SETUP.bash && cd

The values in SETUP.bash assume:

  1. You are on 'gsliscluster1' which has Hadoop 2.6 installed
     (the Spark code make use of HDFS and Yarn that comes with this).
  2. The ingested JSON files are streamed over to a cloud configuration
     of Solr set up on 'solr1' and 'solr2'
  3. You have setup ssh so you can log into the nodes in the Hadoop/Spark
     cluster (gc1, gc2, etc) without needing to enter your password




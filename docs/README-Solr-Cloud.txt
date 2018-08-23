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

This README file covers Component (ii) Solr-Cloud

Installation
============

The install scripts expect 'git', a JDK and 'unzip' to be installed on
the Linux distro.  For monitoring CPU usage, 'htop' is also a useful
utility to have.  Using 'apt-get' these can be installed with:

  sudo apt-get install git oracle-j2sdk1.8 unzip htop


To check out the code needed to run the Solr cloud,
do the following:

  git clone https://github.com/htrc/HTRC-Solr-EF-Setup
  cd HTRC-Solr-EF-Setup/
  git clone https://github.com/htrc/HTRC-Solr-EF-Cloud
  ./GET-PACKAGES-SOLR7.sh
  ./GET-PACKAGES-ZOOCREEPER.sh 

ZooCreeper is a package that allows ZooKeeper files to
be backed up. ./GET-PACKAGES-ZOOCREEPER.sh downloads
the Java source code and compiles it.

If you do not have JAVA_HOME explictly set, it will default to:
   /usr/lib/jvm/j2sdk1.8-oracle

In the instruction below this has been done in the /homea/solr-ef/ directory,
and assumes a 20 Solr cloud is to be run across solr1 and solr2.

  Modify the relevant statements according if installing in a different
  directory.

  Modify the environment variables set in SETUP.bash (see below) if your
  cloud configuration is different.

Setup
=====

To setup your environment to run this code, edit your ~/.bashrc file to include:

  source /homea/solr-ef/HTRC-Solr-EF-Setup/SETUP.bash

The values in SETUP.bash assume:

  1. The installed Solr cloud consists of 20 nodes spread 'solr1' and 'solr2'
  2. The configuration files to the Solr cloud a shared through a Zookeeper
     installation running on port 8181

Having updated your .bashrc file, open a new terminal session on solr1
for the SETUP.bash file to take effect.

Next, ensure you can 'locally' ssh to the machines where the solr
nodes run without being prompted for a password.  For example,
when logged in to 'solr1' you can run:

  ssh solr1 ls
  ssh solr2 ls

without needing to enter your password.


[
  In the case where HTRC-Solr-EF-Setup is not on a networked disk,
  then using rsync once things have been set up on one machine to
  clone the files to the other machines is useful.  Having
  set up one machine (e.g. sol3), for each other host machine in
  the mix you could do the following:

    sudo mkdir /opt/HTRC-Solr-EF-Setup
    sudo chown $username /opt/HTRC-Solr-EF-Setup
    sudo chgrp htrc /opt/HTRC-Solr-EF-Setup
    sudo chmod g+s /opt/HTRC-Solr-EF-Setup

    cd /opt/
    rsync -pavH solr3:/opt/HTRC-Solr-EF-Setup/. HTRC-Solr-EF-Setup/.

  Similarly for where the jetty servers that solr uses are located
    
    sudo mkdir /var/local/htrc-ef-jetty-servers
    sudo chown dbbridge /var/local/htrc-ef-jetty-servers
    sudo chgrp htrc /var/local/htrc-ef-jetty-servers
    sudo chmod g+s /var/local/htrc-ef-jetty-servers

    ssh solr4
    ...


]


Finally, each solr node in the cluster needs to run its own Jetty
server.  To set these up, run:

  htrc-ef-solr-setup-local-disk-all.sh

Compilation
===========

The script ./GET-PACKAGES-SOLR7.sh downloads Java binary code so there
is no compilation step needed to run the Solr cloud.

Running Solr
============

The checked-out Solr is configured to run with ZooKeeper.  Start
ZooKeeper first with:

 htrc-ef-zookeeper-start.sh

Then start up the Solr cloud with

 htrc-ef-solr-start-all.sh

which spins up the 20 Jetty servers, 10 running on solr1 and 10 running on solr2






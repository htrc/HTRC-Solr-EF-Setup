./GET-PACKAGES-SOLR7.sh
./GET-PACKAGES-ZOOCREEPER.sh 

git clone https://github.com/htrc/HTRC-Solr-EF-Cloud

echo $JAVA_HOME
if not set, will default to
   "/usr/lib/jvm/j2sdk1.8-oracle"
    
ensure can ssh in to machines (solr1 solr2) from solr1 without password


add SETUP.bash in .bashrc file

open new terminal

htrc-ef-zookeeper-start-all.sh

htrc-ef-solr-setup-local-disk-all.sh
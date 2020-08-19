
###
# Install needed packages

sudo apt-get install git unzip htop nmap

# sudo apt-get install oracle-j2sdk1.8
sudo apt-get install openjdk-11-jdk-headless


###
# SOLR8_SERVER_BASE_JETTY_DIR, set in SETUP8.bash, specifies
# a directory area for set of jetty servers that are run
#
# As this includes logging all the web server calls made,
# which can be substantial when indexing/ingesting, so setting
# this up as a symbolic link to a spot on a local disk with
# decent space free is preferable


# (Values used on solr3-6)
# solr8_dataroot=/
# solr8_jettyservers=/disk1/solr8-jetty-servers
# solr8_group=htrc

# (Values used on solr7-8)
solr8_dataroot=/solr-data
solr8_jettyservers=/solr-data/solr8-jetty-servers
solr8_group="htrc-solr"

ls -la "$solr8_dataroot"
sudo chmod a+rwx "$solr8_dataroot"
ls -la "$solr8_dataroot"

# create local directory area ...
sudo mkdir "$solr8_jettyservers"
sudo chmod 775 "$solr8_jettyservers"
ls -la "$solr8_jettyservers"
sudo chown www-data "$solr8_jettyservers"
sudo chgrp $solr8_group "$solr8_jettyservers"
sudo chmod g+s "$solr8_jettyservers"
ls -la "$solr8_jettyservers"

# ... and symlink across to it
sudo ln -s "$solr8_jettyservers" "$SOLR8_SERVER_BASE_JETTY_DIR"
ls -ld "$SOLR8_SERVER_BASE_JETTY_DIR"
ls -ld "$SOLR8_SERVER_BASE_JETTY_DIR"/


for d in node1 node2 node3 node4 node5 node6 node7 node8 ; do
  full_d="$solr8_dataroot/$d"
  echo "Creating directcory $full_d"
  mkdir "$full_d"
  sudo chown www-data "$full_d"
  sudo chgrp $solr8_group "$full_d"
  sudo chmod g+s "$full_d"
done  

###
# Get ready to use git: set user details for git

git config --global user.name "<Your Name>"
git config --global user.email "<username>@<your.institute.edu>"

# Skip'--global' and do within checked git repo if looking to
# set these details more locally

# Set EDITOR in ~/.bashrc to favourite text editor, e.g.:
  emacs ~/.bashrc
  export EDITOR=emacs

###
# Check out top-level project files from git,
#   and setup shared group file permissions

cd
git clone  https://github.com/htrc/HTRC-Solr-EF-Setup

# Assuming you are in the group 'htrc-solr' ...
chgrp -R $solr8_group HTRC-Solr-EF-Setup
find HTRC-Solr-EF-Setup -type d -exec chmod g+s {} \; -print

sudo mv HTRC-Solr-EF-Setup /opt/.

ln -s /opt/HTRC-Solr-EF-Setup HTRC-Solr-EF-Setup-Robust-solr345678

cd HTRC-Solr-EF-Setup-Robust-solr345678/

###
# Now get Solr Cloud scripts and set things up for operation

git clone https://github.com/htrc/HTRC-Solr-EF-Cloud

./GET-PACKAGES-SOLR8.sh

./GET-PACKAGES-ZOOCREEPER.sh
mv zoocreeper-master zoocreeper-master-for-solr8

#***
# Review SETUP8.bash, then ...
#***
source ./SETUP8.bash

# Update Jetty to allow cross-origin (CORS) AJAX calls
# and use realm authentication for Solr admin interface
#
./SOLR8-JETTY-SET-PASSWORD.sh
./SOLR8-JETTY-TOPUP.sh

# Add in the HTRC custom scheme used for Solr search
./SOLR8-TOPUP-CONFIGSETS.sh

###
# You now have the local top-level 'jetty+solr' folder primed
# with everything you need.  It's now time to distribute these
# files across all the machines in the solr cluster


# Make sure you can ssh to the other machines in the solr cluster without
# being prompted for a password (or add key message) e.g.:

ssh solr3 ls
ssh solr4 ls
ssh solr5 ls
ssh solr6 ls
ssh solr7 ls
ssh solr8 ls


####
# Rsync the prepared jetty+solr folder across all the
# designated machines and directory names, as specified
# in SOLR8_NODES and SOLR8_SHARDS

# Consider having ALL-CAPS wrapper script to this "INIT ..."
htrc-ef-solr8-setup-local-disk-all.sh

./INIT-ZOOKEEPER-ENSEMBLE-FOR-SOLR8-CONFIGS.sh

# Consider having ALL-CAPS wrapper script to this "INIT ..."
htrc-ef-solr8-upload-config.sh


###
# Set things up so SETUP8.bash is automatically sourced

# Add to ~/.bashrc
#   Near the start, and *particularly* *important* (if present) in front of:

---
# If not running interactively, don't do anything                                                                                                               
case $- in
    *i*) ;;
      *) return;;
esac
---


emacs ~/.bashrc

  if [ -f /opt/HTRC-Solr-EF-Setup/SETUP8.bash ] ; then
    export SOLR8_AUTH_TYPE="basic"
    export SOLR8_AUTHENTICATION_OPTS='-Dbasicauth=admin:<password-changeme>'

    source /opt/HTRC-Solr-EF-Setup/SETUP8.bash    
  fi

###


# Double check and make sure the pool of jetty servers has write access as 'www-data:htrc-solr'
#   By this point, the group permission should be set to 'htrc-solr', it might not be group writable
#   Owner of the files might be the user where the install work has been done rather than 'www-data'

pushd /usr/local/solr8-jetty-servers/
sudo chown -R www-data .
sudo chmod -R g+w .
popd

pushd HTRC-Solr-EF-Cloud/service.d/
sudo ./INSTALL-SERVICE8.sh 
popd


sudo /bin/systemctl enable solrnodes8
# Created symlink /etc/systemd/system/multi-user.target.wants/solrnodes8.service → /etc/systemd/system/solrnodes8.service.

sudo visudo
dbbridge ALL = NOPASSWD: /bin/systemctl

# ... continue with ', /sbin/start' if other commands

# man 5 limits.conf
sudoedit /etc/security/limits.conf
solr	 hard	nofile	65000
solr	 hard	nproc	65000
solr	 soft	nofile	65000
solr	 soft	nproc	65000

./SOLR8-SYSTEMCTL-ALL.sh status
./SOLR8-SYSTEMCTL-ALL.sh start
./SOLR8-SYSTEMCTL-ALL.sh stop


###
# Make Solr Admin interface publicly accessable 

# On solr1 and solr2, update apache config files so
# solr cloud has a public facing URL access point

# e.g.,

ssh solr1
cd /etc/apache2/sites-enabled/
ls
sudo emacs *.conf

# add:
        ProxyPass /robust-solr8 http://solr3:9983/solr
	ProxyPassReverse /robust-solr8 http://solr3:9983/solr
	<Location /robust-solr8>
		ProxyPassReverseCookiePath /solr8 /solr8
	</Location>

sudo service apache2 restart

# Repeat conf edits + restart for solr2


 *** [WARN] *** Your open file limit is currently 1024.
Jun 01 06:10:45 is-solr3.ischool.illinois.edu env[836]: It should be set to 65000 to avoid operational disruption.
Jun 01 06:10:45 is-solr3.ischool.illinois.edu env[836]: If you no longer wish to see this warning, set SOLR_ULIMIT_CHECKS to false in your profile or solr.in.sh
Jun 01 06:10:51 is-solr3.ischool.illinois.edu env[836]: [194B blob data]


solr3456-faceted-htrc-full-ef16
solr3456-faceted-htrc-full-ef16

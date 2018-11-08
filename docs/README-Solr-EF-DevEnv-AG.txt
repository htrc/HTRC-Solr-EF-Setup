How to Setup Solr-EF Searching within HTRC-DevEnvironment, Analytics Gateway
============================================================================


Make sure VirtualBox and Vagrant are up to date
  sudo apt-get ....


Cribbed from main README.md file:

  vagrant plugin vagrant-hostmanager vagrant-vbguest vagrant-triggers

Yes, it still looks like the community version 'triggers' is needed/used

  export VAGRANT_USE_VAGRANT_TRIGGERS=1

if you want to stop seeing the warning when running vagrant commands.


Now build the Linux VM and get all its packages set up

  vagrant up

  [enter host (bedrock) user's password when prompted]

When prompted for a password, this is so it can update /etc/hosts on
your *host* machine through a sudo command.  Assuming your account has
sudo access, enter your password.  If you get it wrong, or don't have
sudo powers, then the script will continue but be aware that web
access from the host machine will likely be broken, and you will need
to use use something like VNC to remote desktop to the VM and run a
browser from there.


As of 28/9/18 on bedrock 'vagrant up' stops with an error about
kernel-headers being missing:

For the given combination of VirtualBox, Vagrant and the Linux
distribution for the VM used this results in an error when trying to
add in Guest Additions to the VM, as the wrong kernel headers have
been install.  The issue can be 'flushed' out with:
  vagrant ssh
      sudo yum update
          exit

The restart the provisioning process with:

  vagrant reload --provision


****

Assuming that complete (takes a while!), then to get the analytics web
site up and running:

Once off:

I have found that SELinux can be a bit touchy as to whether the config
files for Nginx are acceptable.  Simplest solution, as it is a dev
build, is to turn it off completely and restart the machine:

  vangrant ssh
      emacs -nw /etc/selinux/config
          DISABLED
	      exit

  vagrant halt

Also, once off, it is convenient to set up a symbolic-link to
where the Analytics-Gateway code is:

  vagrant up
    vagrant ssh

    ln -s /devenv_sources/Analytics-Gateway
        cd Analytics-Gateway


Start all the services:

The 'wso2is' service is typically already running:

  sudo systemctl status wso2is

If not:

  sudo systemctl start wso2is

Then:

  sudo systemctl start tomcat

  sudo systemctl start nginx

Finally in Analytics-Gateway

  sbt run

[This can take a while the first time it is run]



# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'
config = YAML.load_file('config.yaml')

VAGRANT_BOX = 'ubuntu/xenial64'
VM_NAME = config['vm.name']
VM_PW = config['vm.password']
VM_MONITOR_COUNT = config['vm.monitor.count']
USER_NAME = config['user.name']
USER_EMAIL = config['user.email']
SSH_KEY_PW = config['ssh.key.password']
DEFAULT_LXPANEL = '/usr/share/lxpanel/profile/Lubuntu/panels/panel'
HOME = '/home/ubuntu'

Vagrant.configure(2) do |config|

  config.vm.box = VAGRANT_BOX
  config.vm.hostname = VM_NAME
  config.ssh.forward_x11 = true
  config.disksize.size = "20GB"
  
  config.vm.provider "virtualbox" do |v|
    v.name = VM_NAME
    v.memory = 4096
    v.cpus = 4
    v.gui = true
    v.customize ["modifyvm", :id, "--usb", "on"]
    v.customize ["modifyvm", :id, "--usbxhci", "on"]
    v.customize ["modifyvm", :id, "--vram", "64"]
	v.customize ["modifyvm", :id, "--monitorcount", "#{VM_MONITOR_COUNT}"]
	v.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
  end
  
  config.vm.provision "docker"
  config.vm.provision "main", type: "shell", args: [VM_PW, USER_NAME, USER_EMAIL, HOME], inline: <<-SHELL
	VM_PW=$1
	USER_NAME=$2
	USER_EMAIL=$3
	HOME=$4
    
	# Installations, common configs
    OPT_SILENT='-qq -y'
  
    sudo echo "LANG=en_US.UTF-8" >> /etc/environment
    sudo echo "LANGUAGE=en_US.UTF-8" >> /etc/environment
    sudo echo "LC_ALL=en_US.UTF-8" >> /etc/environment
    sudo echo "LC_CTYPE=en_US.UTF-8" >> /etc/environment
    
    echo ubuntu:$VM_PW | sudo chpasswd
    sudo timedatectl set-timezone Europe/Berlin
    sudo echo "setxkbmap de" >> /etc/profile
    
    add-apt-repository -y ppa:webupd8team/java
    
    sudo apt-get -qq update
    sudo apt-get -y upgrade
    
    echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections 
    echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
    
    sudo apt-get $OPT_SILENT install oracle-java8-installer git pgadmin3
    sudo apt-get $OPT_SILENT install lubuntu-desktop
	sudo apt-get $OPT_SILENT install virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11
    sudo echo "allowed_users=anybody" > /etc/X11/Xwrapper.config
	
	mkdir $HOME/repositories
	sudo chown -R ubuntu /opt $HOME/repositories 
	
	# Git
	sudo echo -e "[user]\n\tname = $USER_NAME\n\temail = $USER_EMAIL" >> $HOME/.gitconfig
  SHELL
  #config.vm.provision "eclipse", type: "shell", args: [USER_NAME, USER_EMAIL, DEFAULT_LXPANEL], path: "setup_eclipse.sh"
  config.vm.provision "idea", type: "shell", args: [USER_NAME, USER_EMAIL, DEFAULT_LXPANEL], path: "setup_idea.sh"
  
  #lxpanel setup moved in separate script due to issues with escaping of sed strings in inline shell script
  config.vm.provision "lxpanel", type: "shell", args: [DEFAULT_LXPANEL], path: "setup_lxpanel.sh"
  
  config.vm.provision "final", type: "shell", args: [VM_NAME, SSH_KEY_PW, HOME], inline: <<-SHELL
	VM_NAME=$1
	SSH_KEY_PW=$2
	HOME=$3
	
	# SSH
	ssh-keygen -t rsa -b 4096 -C "Key for VM $VM_NAME" -N $SSH_KEY_PW -f $HOME/.ssh/id_rsa -q
	
	echo "\n#########################\nSSH key generated. Add the key to your GitLab account:\n#########################\n"
	cat $HOME/.ssh/id_rsa.pub
	
	sudo chown -R ubuntu $HOME/.ssh
	
	# Clean up
	sudo apt-get $OPT_SILENT autoremove
	sudo apt-get $OPT_SILENT autoclean
	
    echo "rebooting..."
    sudo reboot
  SHELL
end

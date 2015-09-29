# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_NAME = ENV["BOX_NAME"] || "trusty"
BOX_URI = ENV["BOX_URI"] || "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
BOX_MEMORY = ENV["BOX_MEMORY"] || "2048"
BOX_CPUS = ENV["BOX_CPUS"] || "1"
RUN_TESTS = ENV["RUN_TESTS"]
PTERO_CHECKOUT = ENV["PTERO_CHECKOUT"]

Vagrant::configure("2") do |config|
  config.ssh.forward_agent = true
  config.vm.network "private_network", ip: "192.168.20.20"

  config.vm.box = BOX_NAME
  config.vm.box_url = BOX_URI

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--memory", BOX_MEMORY]
    vb.customize ["modifyvm", :id, "--cpus", BOX_CPUS]
  end

  config.vm.provision 'apt-get update',             type: "shell", inline: "apt-get update"
  config.vm.provision 'apt-get install',            type: "shell", inline: "apt-get -qq -y install git python-dev python-pip rabbitmq-server redis-server postgresql libpq-dev"

  if PTERO_CHECKOUT
    config.vm.synced_folder ".", "/home/vagrant/.ptero-synced-folder"
    config.vm.provision 'copy ptero to $HOME', type: "shell", privileged: false, inline: "rsync -aLq ~/.ptero-synced-folder/ ~/ptero --exclude='*.tox*' --exclude='*.vagrant*'"
  else
    config.vm.provision 'clone ptero', type: "shell", privileged: false, inline: "git clone http://github.com/genome/ptero.git"
    config.vm.provision 'initialize submodules', type: "shell", privileged: false, inline: "cd ~/ptero; git submodule update --init"
  end

  config.vm.provision 'use bash instead of dash',   type: "shell", inline: "update-alternatives --install /bin/sh sh /bin/bash 100"
  config.vm.provision 'pip install tox',            type: "shell", inline: "pip install tox"
  config.vm.provision 'set postgres auth-method',   type: "shell", inline: 'echo -e "local all all trust\nhost all all 127.0.0.1/32 trust" > /etc/postgresql/9.3/main/pg_hba.conf && service postgresql restart'
  config.vm.provision 'launch services',            type: "shell", privileged: false, inline: "cd ~/ptero/services/workflow; tox -re dev -- --logdir=var/log --daemondir=var/run"

  if RUN_TESTS
    config.vm.provision 'run tests', type: "shell", privileged: false, inline: "cd ~/ptero/services/workflow; tox -e tests-only -- -v 2>&1"
  end

end

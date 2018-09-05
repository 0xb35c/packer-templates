# Alpine 3.8 with Docker

Vagrant Box for Alpine 3.8 with Docker

Includes:

- Basic [Vagrant](https://www.vagrantup.com/) user setup 
- [Docker](https://www.docker.com/)
- [Chrony](https://chrony.tuxfamily.org/) for NTP with settings for VM sleep
- 50 GB sparse disk for all your Docker images


## Usage

You will need [vagrant-alpine](https://github.com/maier/vagrant-alpine) plugin
to make full use of this Vagrant box:

    vagrant plugin install vagrant-alpine

Create a [VirtualBox](https://www.virtualbox.org/wiki/Downloads) VM 
with [Vagrant](https://www.vagrantup.com/):

    vagrant init <name> <path_to_box>
    vagrant up
    vagrant ssh

### Exposed Docker Socket

**WARNING:** _Anyone having access to the docker socket can easily get root access to the system hosting the containers. Do **NOT** expose the docker socket to the internet or your internal network._

The following vagrant file can be used to expose the docker socket to Virtualbox' host-only network. As such it is possible to use the docker cli from the host system.
```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define "dev" do |dev|
    dev.vm.network "private_network", ip: "192.168.56.10"
    dev.vm.box = "alpine_with_docker"

    # Make sure NOT to expose the docker socket to any other network than your host only network.
    dev.vm.provision "shell", inline: <<-SHELL
        sed -ir 's@DOCKER_OPTS=.*@DOCKER_OPTS="-H unix:///var/run/docker.sock -H tcp://192.168.56.10:2375"@' /etc/conf.d/docker
        service docker restart
    SHELL

    dev.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
    end
  end
end
```
Afterwards you need to set the correct environment variable to let docker know where to talk:

    export DOCKER_HOST=192.168.56.10:2375
    docker ps

## Credits
Based on https://github.com/pulsesecure/vagrant-alpine-3.3-x86_64-docker
set -eux

# Install Vagrant insecure key for initial SSH setup as per
# https://www.vagrantup.com/docs/boxes/base.html
mkdir -pm 700 /home/vagrant/.ssh
wget -O - 'https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub' > /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh
chmod 0600 /home/vagrant/.ssh/authorized_keys

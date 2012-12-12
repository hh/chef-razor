# razor cookbook

[![Build Status](https://secure.travis-ci.org/cloudbau/chef-razor.png)](http://travis-ci.org/cloudbau/chef-razor)

## Requirements

## Usage

Configures and installs razor to provision bare-metal nodes

### Lab environment

- Install vagrant [[http://downloads.vagrantup.com]]
- Install berkshelf [[http://berkshelf.com]]
	- `bundle install` 

start the razor server

	vagrant up default

wait until it is provisioned

	vagrant ssh
	sudo -i
	/opt/razor/bin/razor image add -t mk -p /opt/razor/rz_mk_prod-image.0.9.1.6.iso
   # download ubuntu
	/opt/razor/bin/razor image add -t os -p /home/vagrant/ubuntu-12.04-server-amd64.iso -n ubuntu_precise_full -v 12.04
   /opt/razor/bin/razor policy add --template=linux_deploy --label=precise --model-uuid=4V0ohCus02ClmQ2nVadmwa --broker-uuid=none --tags=virtualbox_vm --enabled=true
   /opt/razor/bin/razor model add --template=ubuntu_precise --label=install_precise --image-uuid=vxVmUvms32tiCaAcD96rY

   ./razor active_model

start the pxe client

	vagrant up pxe-test-1	

enjoy

## Attributes

## Data Bags

## Recipes

## ToDo

- optimize ruby options (no source compile needed)
- optimize nodejs options (no source compile needed)
- add LWRP for mk and os images
- document the hell out of it

# Author

Author:: Edmund Haselwanter (e.haselwanter@cloudbau.de)

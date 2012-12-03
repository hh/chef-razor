# razor cookbook

# Requirements

# Usage

Configures and installs razor to provision bare-metal nodes

## Lab environment

- Install vagrant [[http://downloads.vagrantup.com]]
- Install berkshelf [[http://berkshelf.com]]
	- `bundle install` 

start the razor server

	vagrant up default

wait until it is provisioned

	vagrant ssh
	sudo -i
	/opt/razor/bin/razor image add -t mk -p /opt/razor/rz_mk_prod-image.0.9.1.6.iso

start the pxe client

	vagrant up pxe-test-1	

enjoy

# Attributes

# Recipes

# Author

Author:: Edmund Haselwanter (e.haselwanter@cloudbau.de)

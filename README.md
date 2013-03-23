# razor cookbook

[![Build Status](https://secure.travis-ci.org/cloudbau/chef-razor.png)](http://travis-ci.org/cloudbau/chef-razor)

## Requirements

## Usage

Configures and installs razor to provision bare-metal nodes

### Lab environment

- Install vagrant [http://downloads.vagrantup.com](http://downloads.vagrantup.com)
- Install berkshelf [http://berkshelf.com](http://berkshelf.com) as a chef_gem
```sudo /opt/chef/embedded/bin/gem install berkshelf```
- Do not use `bundle install` 

get the cookbooks and start the razor server

  berks install --path ./cookbooks
	vagrant up default

wait until it is provisioned

```
vagrant ssh default
sudo -i
cd /opt/razor/bin/

./razor image add -t mk -p /opt/razor/rz_mk_prod-image.0.9.1.6.iso
# download ubuntu
# e.g. via 
# curl -o /home/vagrant/ubuntu-12.04.1-server-amd64.iso http://releases.ubuntu.com/precise/ubuntu-12.04.1-server-amd64.iso
./razor image add -t os -p /home/vagrant/ubuntu-12.04.1-server-amd64.iso -n ubuntu_precise_full -v 12.04
#
# Either enter the model details manually or add this command before the next command
# 
#  echo -e "node\nusername\npassword" |
#
./razor model add --template=ubuntu_precise --label=install_precise --image-uuid=<IMAGE_UUID>
./razor policy add --template=linux_deploy --label=precise --model-uuid=<MODEL_UUID> --broker-uuid=none --tags=virtualbox_vm --enabled=true

./razor active_model
```

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

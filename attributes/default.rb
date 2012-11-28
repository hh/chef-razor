#
# Cookbook Name:: razor
# Attributes:: default
#
# Copyright (C) 2012 cloudbau
# 
# Authors:
#       Edmund Haselwanter <e.haselwanter@cloudbau.de>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default[:razor][:directory]           = '/opt/razor'
default[:razor][:address]             = node[:ipaddress]
default[:razor][:persist_host]        = '127.0.0.1'
default[:razor][:mk_checkin_interval] = '60'
default[:razor][:mk_name]             = 'rz_mk_prod-image.0.9.1.6.iso'
default[:razor][:mk_source]           = 'https://github.com/downloads/puppetlabs/Razor-Microkernel/rz_mk_prod-image.0.9.1.6.iso'
default[:razor][:git_source]          = 'http://github.com/fnichol/Razor.git'
default[:razor][:git_revision]        = 'master'
default[:razor][:git_action] 		  =  :sync
default[:razor][:ruby_version]        = '1.9.3-p327'

default[:razor][:user]            = 'razor'

case node[:platform]
when "debian", "ubuntu"
  default[:razor][:group] = "nogroup"
else
  default[:razor][:group] = node[:razor][:user]
end


# 
# server config opts
#
api_port = 8026
host_ip = ipaddress
default[:razor][:admin_port] = 8025
default[:razor][:api_port] = api_port
default[:razor][:api_host] = ipaddress
default[:razor][:image_host] = host_ip
default[:razor][:image_port] = 8027
default[:razor][:image_dir] = "#{razor_dir}/image"
default[:razor][:mk_uri] = "http://#{host_ip}:#{api_port}" 
default[:razor][:persist_host] = "127.0.0.1"
default[:razor][:persist_port] = "27017"
default[:razor][:persist_mode] = ":mongo"
default[:razor][:debug_level] = ""

  
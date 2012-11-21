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
default[:razor][:ruby_version]        = '1.9.3-p327'

default[:razor][:user]            = 'razor'

case node[:platform]
when "debian", "ubuntu"
  default[:razor][:group] = "nogroup"
else
  default[:razor][:group] = node[:razor][:user]
end
  
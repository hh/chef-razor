#
# Cookbook Name:: razor
# Recipe:: default
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

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

rbenv_ruby node[:razor][:ruby_version]

%W{autotest base62 bson bson_ext colored daemons json logger macaddr mocha mongo net-ssh require_all syntax uuid}.each do |gem_package|

	rbenv_gem gem_package do
	  ruby_version node[:razor][:ruby_version]
	end

end

include_recipe "nodejs::install_from_source"
include_recipe "nodejs::npm"

npm_package "express@2.5.11"
npm_package "mime"

include_recipe "mongodb::10gen_repo"
include_recipe "mongodb::default"

user  node[:razor][:user] { action :create }
group  node[:razor][:group] { action :create }

directory node[:razor][:directory] do
  recursive true
  owner node[:razor][:user]
  group node[:razor][:group]
  mode 0755
end

default[:tftp][:username] = node[:razor][:user]

include_recipe "tftp"
include_recipe "dhcp"

git node[:razor][:directory] do                            
    repository [:razor][:git_source] 
    revision [:razor][:git_revision]                                    
    action [:razor][:git_action]                                     
  	owner node[:razor][:user]
  	group node[:razor][:group] 
end

service "razor_server" do
  action :nothing
end

template "#{node[:razor][:directory]}/conf/razor_server.conf" do
  variables( 
    :mk_uri => node[:razor][:mk_uri],
    :api_port => node[:razor][:api_port],
    :admin_port => node[:razor][:admin_port],
    :image_host => node[:razor][:image_host],
    :image_port => node[:razor][:image_port],
    :image_path => node[:razor][:image_dir],
    :persist_mode => node[:razor][:persist_mode],
    :persist_host => node[:razor][:persist_host],
    :persist_port => node[:razor][:persist_port],
    :debug_leve => node[:razor][:debug_level]
   )
   notifies :restart, "service[razor_server]", :delayed 
end 

service "razor_server" do
  action :start
  start_command "#{razor_dir}/bin/razor_daemon.rb start" 
  stop_command "#{razor_dir}/bin/razor_daemon.rb stop" 
  restart_command "#{razor_dir}/bin/razor_daemon.rb restart" 
  reload_command "#{razor_dir}/bin/razor_daemon.rb reload" 
  status_command "#{razor_dir}/bin/razor_daemon.rb status"
  supports  :restart => true, :status => true 
end



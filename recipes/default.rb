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

rbenv_ruby node[:razor][:ruby_version] do
  global true
end

%W{autotest base62 bson bson_ext colored daemons json logger macaddr mocha mongo net-ssh require_all syntax uuid}.each do |gem_package|

	rbenv_gem gem_package do
	  ruby_version node[:razor][:ruby_version]
	end

end

include_recipe "nodejs::install_from_source"
include_recipe "nodejs::npm"

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

node.set[:tftp][:username] = node[:razor][:user]

include_recipe "tftp"

include_recipe "razor::isc-dhcp"

git node[:razor][:directory] do                            
    repository node[:razor][:git_source] 
    revision node[:razor][:git_revision]                                    
    action node[:razor][:git_action]                                     
  	user node[:razor][:user]
  	group node[:razor][:group] 
end

%W{express@2.5.11 mime}.each do |node_pkg|
  npm_package node_pkg do
    action :install_local 
    path File.join(node[:razor][:directory],"bin")
  end
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
  start_command ". /etc/profile.d/rbenv.sh ; #{node[:razor][:directory]}/bin/razor_daemon.rb start" 
  stop_command ". /etc/profile.d/rbenv.sh ; #{node[:razor][:directory]}/bin/razor_daemon.rb stop" 
  restart_command ". /etc/profile.d/rbenv.sh ; #{node[:razor][:directory]}/bin/razor_daemon.rb restart" 
  reload_command ". /etc/profile.d/rbenv.sh ; #{node[:razor][:directory]}/bin/razor_daemon.rb reload" 
  status_command ". /etc/profile.d/rbenv.sh ; #{node[:razor][:directory]}/bin/razor_daemon.rb status"
  supports  :restart => true, :status => true 
end

remote_file File.join(node[:razor][:directory],node[:razor][:mk_name])  do
  source node[:razor][:mk_source]
  mode 00644
  action :create_if_missing
end

remote_directory node[:tftp][:directory] do
  source "razor-tftp"
  files_mode 00644
  owner "razor"
  group "razor"
  mode 00755
end

template File.join(node[:tftp][:directory],"razor.ipxe") do
  owner "razor"
  group "razor"
  mode 00644  
  variables( 
    :address => node[:razor][:api_host],
    :port => node[:razor][:api_port]
   )
end 




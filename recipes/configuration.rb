#
# Cookbook Name:: keycloak
# Recipe:: configuration
#
# Copyright (C) 2018 Rodel Talampas
# Update for the Keycloak cookbook from Janos Schwellach (https://github.com/jschwellach/chef-keycloak)
# based on the wildfly cookbook from Brian Dwyer (https://github.com/bdwyertech/chef-wildfly)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# This recipe will configure server using Jboss Client Console
#

# => Shorten Hashes
wildfly = node['wildfly']

# => Create Client Configuration Directory
directory "#{wildfly['base']}/client" do
  owner wildfly['user']
  group wildfly['group']
  mode '0755'
  recursive true
end

client_command = ::File.join(wildfly['base'], 'client', 'wildfly-configuration.cli')

template client_command do
  source 'config.cli.erb'
  user wildfly['user']
  group wildfly['group']
  mode '0600'
  action :create
end

execute 'configure_keycloak' do
  command "#{node['wildfly']['base']}/bin/jboss-cli.sh  --file=#{client_command}"
  ignore_failure true
end
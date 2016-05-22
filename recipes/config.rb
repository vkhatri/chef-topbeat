#
# Cookbook Name:: topbeat
# Recipe:: config
#
# Copyright 2015, Virender Khatri
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

file node['topbeat']['conf_file'] do
  content JSON.parse(node['topbeat']['config'].to_json).to_yaml.lines.to_a[1..-1].join
  notifies :restart, 'service[topbeat]' if node['topbeat']['notify_restart'] && !node['topbeat']['disable_service']
end

service_action = node['topbeat']['disable_service'] ? [:disable, :stop] : [:enable, :start]

powershell_script 'install topbeat as service' do
  code "#{node['topbeat']['windows']['base_dir']}/topbeat-#{node['topbeat']['version']}-windows/install-service-topbeat.ps1"
end if node['platform'] == 'windows'

ruby_block 'delay topbeat service start' do
  block do
  end
  notifies :start, 'service[topbeat]'
  not_if { node['topbeat']['disable_service'] }
end

service 'topbeat' do
  supports :status => true, :restart => true
  action service_action
end

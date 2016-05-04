package_url = node['topbeat']['package_url'] == 'auto' ? "https://download.elastic.co/beats/topbeat/topbeat-#{node['topbeat']['version']}-windows.zip" : node['topbeat']['package_url']

package_file = ::File.join(Chef::Config[:file_cache_path], ::File.basename(package_url))

remote_file 'topbeat_package_file' do
  path package_file
  source package_url
  not_if { ::File.exist?(package_file) }
end

directory node['topbeat']['windows']['base_dir'] do
  recursive true
  action :create
end

windows_zipfile node['topbeat']['windows']['base_dir'] do
  source package_file
  action :unzip
  not_if { ::File.exist?(node['topbeat']['windows']['base_dir'] + "/topbeat-#{node['topbeat']['version']}-windows" + '/install-service-topbeat.ps1') }
end

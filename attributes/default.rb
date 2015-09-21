default['topbeat']['version'] = '1.0.0-beta3'
default['topbeat']['disable_service'] = false

default['topbeat']['package_url'] = value_for_platform_family(
  'debian' => "https://download.elasticsearch.org/beats/topbeat/topbeat_#{node['topbeat']['version']}_amd64.deb",
  %w(rhel fedora) => "https://download.elasticsearch.org/beats/topbeat/topbeat-#{node['topbeat']['version']}-x86_64.rpm"
)

default['topbeat']['packages'] = []

default['topbeat']['notify_restart'] = true

default['topbeat']['conf_dir'] = '/etc/topbeat'
default['topbeat']['conf_file'] = ::File.join(node['topbeat']['conf_dir'], 'topbeat.yml')

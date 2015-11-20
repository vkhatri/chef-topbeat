default['topbeat']['version'] = '1.0.0-rc2'
default['topbeat']['disable_service'] = false
default['topbeat']['package_url'] = 'auto'
default['topbeat']['packages'] = []
default['topbeat']['notify_restart'] = true
default['topbeat']['conf_dir'] = '/etc/topbeat'
default['topbeat']['conf_file'] = ::File.join(node['topbeat']['conf_dir'], 'topbeat.yml')

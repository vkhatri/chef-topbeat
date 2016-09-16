default['topbeat']['version'] = '1.3.1'
default['topbeat']['release'] = '1'
default['topbeat']['disable_service'] = false
default['topbeat']['package_url'] = 'auto'
default['topbeat']['packages'] = []
default['topbeat']['notify_restart'] = true
default['topbeat']['windows']['base_dir'] = 'C:/opt/topbeat'
default['topbeat']['conf_dir'] = if node['platform'] == 'windows'
                                   "#{node['topbeat']['windows']['base_dir']}/topbeat-#{node['topbeat']['version']}-windows"
                                 else
                                   '/etc/topbeat'
                                 end
default['topbeat']['conf_file'] = if node['platform'] == 'windows'
                                    "#{node['topbeat']['conf_dir']}/topbeat.yml"
                                  else
                                    ::File.join(node['topbeat']['conf_dir'], 'topbeat.yml')
                                  end

default['topbeat']['yum']['baseurl'] = 'https://packages.elastic.co/beats/yum/el/$basearch'
default['topbeat']['yum']['description'] = 'Elastic Beats Repository'
default['topbeat']['yum']['gpgcheck'] = true
default['topbeat']['yum']['enabled'] = true
default['topbeat']['yum']['gpgkey'] = 'https://packages.elasticsearch.org/GPG-KEY-elasticsearch'
default['topbeat']['yum']['action'] = :create

default['topbeat']['apt']['uri'] = 'https://packages.elastic.co/beats/apt'
default['topbeat']['apt']['description'] = 'Elastic Beats Repository'
default['topbeat']['apt']['components'] = %w(stable main)
default['topbeat']['apt']['action'] = :add
default['topbeat']['apt']['key'] = 'https://packages.elasticsearch.org/GPG-KEY-elasticsearch'

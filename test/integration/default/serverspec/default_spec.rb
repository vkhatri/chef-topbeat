require_relative './spec_helper'

describe 'topbeat::default' do
  it 'should unzip the topbeat package' do
    if os[:family] == 'windows'
      install_sample = file('C:/opt/topbeat/topbeat-1.2.1-windows/install-service-topbeat.ps1')
      expect(install_sample).to be_file
    elsif %w(debian ubuntu redhat).include?(os[:family])
      topbeat_package = package('topbeat')
      expect(topbeat_package).to be_installed
    else
      raise "Unsupported os familty #{os[:family]}"
    end
  end

  it 'should place the topbeat config' do
    if os[:family] == 'windows'
      topbeat_config = file('C:/opt/topbeat/topbeat-1.2.1-windows/topbeat.yml')
    elsif %w(debian ubuntu redhat).include?(os[:family])
      topbeat_config = file('/etc/topbeat/topbeat.yml')
    else
      raise "Unsupported os familty #{os[:family]}"
    end
    expect(topbeat_config).to be_file
  end

  it 'should enable and start the topbeat service' do
    expect(service('topbeat')).to be_enabled
    expect(service('topbeat')).to be_running
  end
end

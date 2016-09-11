require 'spec_helper'

describe 'topbeat::default' do
  shared_examples_for 'topbeat' do
    context 'all_platforms' do
      %w(install config).each do |r|
        it "include recipe topbeat::#{r}" do
          expect(chef_run).to include_recipe("topbeat::#{r}")
        end
      end

      it 'install topbeat package' do
        expect(chef_run).to install_package('topbeat')
      end

      it 'configure /etc/topbeat/topbeat.yml' do
        expect(chef_run).to create_file('/etc/topbeat/topbeat.yml')
      end

      it 'enable topbeat service' do
        expect(chef_run).to enable_service('topbeat')
        expect(chef_run).to start_service('topbeat')
      end
    end
  end

  context 'rhel' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.4') do |node|
        node.automatic['platform_family'] = 'rhel'
      end.converge(described_recipe)
    end

    it 'adds beats yum repository' do
      expect(chef_run).to create_yum_repository('beats')
    end

    it 'add yum_version_lock topbeat' do
      expect(chef_run).to update_yum_version_lock('topbeat')
    end

    include_examples 'topbeat'
  end

  context 'ubuntu' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04') do |node|
        node.automatic['platform_family'] = 'debian'
      end.converge(described_recipe)
    end

    it 'adds beats apt repository' do
      expect(chef_run).to add_apt_repository('beats')
    end

    it 'add beats apt version preference' do
      expect(chef_run).to add_apt_preference('topbeat')
    end

    include_examples 'topbeat'
  end

  context 'windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2012') do |node|
        node.automatic['platform_family'] = 'windows'
      end.converge(described_recipe)
    end

    it 'install topbeat package' do
      expect(chef_run).to run_powershell_script('install topbeat as service')
    end

    it 'delay service start' do
      expect(chef_run).to run_ruby_block('delay topbeat service start')
    end

    it 'download topbeat from web' do
      expect(chef_run).to create_remote_file('topbeat_package_file')
    end

    it 'create install directory' do
      expect(chef_run).to create_directory('C:/opt/topbeat')
    end

    it 'Unpack zip file' do
      expect(chef_run).to unzip_windows_zipfile_to('C:/opt/topbeat')
    end

    it 'configure C:/opt/topbeat/topbeat.yml' do
      expect(chef_run).to create_file('C:/opt/topbeat/topbeat-1.3.0-windows/topbeat.yml')
    end

    it 'enable topbeat service' do
      expect(chef_run).to enable_service('topbeat')
      expect(chef_run).to start_service('topbeat')
    end
  end
end

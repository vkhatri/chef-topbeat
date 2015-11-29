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

    include_examples 'topbeat'
  end
end

require_relative '../../../spec_helper'

describe 'resource_x2go_client_app::debian::8_2' do
  let(:source) { nil }
  let(:action) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'x2go_client_app', platform: 'debian', version: '8.2'
    ) do |node|
      node.set['x2go_client']['app']['source'] = source unless source.nil?
    end
  end
  let(:converge) { runner.converge("resource_x2go_client_app_test::#{action}") }

  context 'the default action (:install)' do
    let(:action) { :default }

    shared_examples_for 'any attribute set' do
      it 'ensures the apt cache is up to date' do
        expect(chef_run).to include_recipe('apt')
      end
    end

    context 'the default attributes' do
      let(:source) { nil }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'

      it 'configures the X2go APT repo' do
        expect(chef_run).to add_apt_repository('x2go')
          .with(uri: 'http://packages.x2go.org/debian',
                distribution: 'jessie',
                components: %w(main),
                keyserver: 'keys.gnupg.net',
                key: 'E1F958385BFE2B6E')
      end

      it 'installs the x2goclient package' do
        expect(chef_run).to install_package('x2goclient')
      end
    end

    context 'a source attribute' do
      let(:source) { 'https://example.com/x2go.pkg' }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'

      it 'does not configure the X2go APT repo' do
        expect(chef_run).to_not add_apt_repository('x2go')
      end

      it 'installs the source package' do
        expect(chef_run).to install_package(source)
      end
    end
  end

  context 'the :remove action' do
    let(:action) { :remove }
    cached(:chef_run) { converge }

    it 'removes the x2goclient package' do
      expect(chef_run).to remove_package('x2goclient')
    end

    it 'removes the X2go APT repo' do
      expect(chef_run).to remove_apt_repository('x2go')
    end
  end
end
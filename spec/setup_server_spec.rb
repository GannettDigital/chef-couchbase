# encoding: utf-8
require 'chefspec'
require 'spec_helper'
require 'fauxhai'

describe 'couchbase::setup_server' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      stub_command("grep '{error_logger_mf_dir, \"/opt/couchbase/var/lib/couchbase/logs\"}.' /opt/couchbase/etc/couchbase/static_config").and_return(0)
    end.converge(described_recipe)
  end
  it 'runs write_services api call' do
    expect(chef_run).to write_couchbase_services('self')
  end

  it 'modifies web settings' do
    expect(chef_run).to modify_couchbase_web_settings('web')
  end

  it 'creates cluster if missing' do
    expect(chef_run).to create_couchbase_cluster('default')
  end

  it 'modifies couchbase pool if existing' do
    expect(chef_run).to modify_couchbase_pool('default')
  end
end

# encoding: utf-8
require 'chefspec'
require 'spec_helper'
require 'fauxhai'

describe 'couchbase::server2' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      stub_command("grep '{error_logger_mf_dir, \"/opt/couchbase/var/lib/couchbase/logs\"}.' /opt/couchbase/etc/couchbase/static_config").and_return(0)
      node.set['ipaddress'] = '10.0.0.1'
      node.set['couchbase']['server']['cluster_master'] = '10.0.0.1'
    end.converge(described_recipe)
  end

  it 'runs install server resource' do
    expect(chef_run).to couchbase_install_server('self')
  end

  it 'enables and starts couchbase-server' do
    expect(chef_run).to enable_service('couchbase-server')
    expect(chef_run).to start_service('couchbase-server')
  end

  it "creates directory /opt/couchbase//var/lib/couchbase/logs" do
    expect(chef_run).to create_directory('/opt/couchbase/var/lib/couchbase/logs').with(user: 'couchbase')
  end

  it 'creates directory /opt/couchbase/var/lib/couchbase/data' do
    expect(chef_run).to create_directory('/opt/couchbase/var/lib/couchbase/data').with(user: 'couchbase')
  end

  it 'rewrites couchbase log_dir config' do
    expect(chef_run).to_not run_ruby_block('rewrite_couchbase_log_dir_config')
  end

  it 'sets node directories' do
    expect(chef_run).to couchbase_node_directories('self')
  end

  it 'runs cluster init' do
    expect(chef_run).to couchbase_cluster_init('self')
  end

end

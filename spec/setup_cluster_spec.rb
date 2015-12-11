# encoding: utf-8
require 'chefspec'
require 'spec_helper'
require 'fauxhai'

describe 'couchbase::setup_cluster' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['ipaddress'] = '10.0.0.1'
      node.set['couchbase']['server']['cluster_master'] = '10.0.0.1'
    end.converge(described_recipe)
  end

end

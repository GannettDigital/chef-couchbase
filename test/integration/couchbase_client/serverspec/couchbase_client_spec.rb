require_relative 'spec_helper'

describe yumrepo('couchbase') do
  it { should exist }
  it { should be_enabled }
end

describe package('libcouchbase2-core') do
  it { should be_installed }
end

describe package('libcouchbase-devel') do
  it { should be_installed }
end

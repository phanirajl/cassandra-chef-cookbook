require 'spec_helper'

describe 'cassandra' do
  describe package('dsc20') do
    it { should be_installed }
  end

  describe service('cassandra') do
    it { should be_enabled }
  end

  # On Centos, C* doesn't start due Java 6 being installed, and not 7.
  # On ubuntu, C* doesn't start due a jamm error.
  # describe service('cassandra') do
  #   it { should be_running }
  # end
end

describe 'cassandra configuration' do
  case os[:family]
  when 'ubuntu'
    cassandra_config = '/etc/cassandra/cassandra.yaml'
  when 'redhat'
    cassandra_config = '/etc/cassandra/conf/cassandra.yaml'
  end

  describe file(cassandra_config) do
    it { should be_file }
  end
end

describe 'cassandra user' do
  describe user('cassandra') do
    it { should exist }
    it { should belong_to_group 'cassandra' }
    it { should have_login_shell '/bin/bash' }
    it { should have_home_directory '/home/cassandra' }
  end
end

describe 'jmx port' do
  describe port(7199) do
    it { should be_listening.on('127.0.0.1').with('tcp') }
    it { should not_be_listening.on('0.0.0.0') }
  end
end

require 'spec_helper'

describe 'collectd::plugin::snmp', type: :class do
  let :pre_condition do
    'include ::collectd'
  end

  let :facts do
    {
      osfamily: 'RedHat',
      collectd_version: '4.8.0',
      operatingsystemmajrelease: '7'
    }
  end

  context ':ensure => present and dataset for AMAVIS-MIB::inMsgs.0' do
    let :params do
      {
        data: {
          'amavis_incoming_messages' => {
            'Type'     => 'counter',
            'Table'    => false,
            'Instance' => 'amavis.inMsgs',
            'Values'   => ['AMAVIS-MIB::inMsgs.0']
          }
        },
        hosts: {
          'scan04' => {
            'Address'   => '127.0.0.1',
            'Version'   => 2,
            'Community' => 'public',
            'Collect'   => ['amavis_incoming_messages'],
            'Interval'  => 10
          }
        }
      }
    end
    it 'Will create /etc/collectd.d/10-snmp.conf' do
      is_expected.to contain_file('snmp.load').with(ensure: 'present',
                                                    path: '/etc/collectd.d/10-snmp.conf',
                                                    content: %r{Data "amavis_incoming_messages".+Instance "amavis.inMsgs".+Host "scan04".+Community "public"}m)
    end
  end

  context ':ensure => absent' do
    let :params do
      {
        ensure: 'absent',
        data: {
          'amavis_incoming_messages' => {
            'Type'     => 'counter',
            'Table'    => false,
            'Instance' => 'amavis.inMsgs',
            'Values'   => ['AMAVIS-MIB::inMsgs.0']
          }
        },
        hosts: {
          'scan04' => {
            'Address'   => '127.0.0.1',
            'Version'   => 2,
            'Community' => 'public',
            'Collect'   => ['amavis_incoming_messages'],
            'Interval'  => 10
          }
        }
      }
    end
    it 'Will not create /etc/collectd.d/10-snmp.conf' do
      is_expected.to contain_file('snmp.load').with(ensure: 'absent',
                                                    path: '/etc/collectd.d/10-snmp.conf')
    end
  end
end

require 'spec_helper'

describe 'collectd::plugin::ethstat', type: :class do
  let :facts do
    {
      osfamily: 'RedHat',
      collectd_version: '4.8.0',
      operatingsystemmajrelease: '7'
    }
  end

  context ':ensure => present, specific params' do
    let :params do
      {
        interfaces: %w(eth0 eth1),
        maps: ['"rx_csum_offload_errors" "if_rx_errors" checksum_offload"', '"multicast" "if_multicast"'],
        mappedonly: false
      }
    end
    it 'Will create /etc/collectd.d/10-ethstat.conf' do
      is_expected.to contain_file('ethstat.load').with(ensure: 'present',
                                                       path: '/etc/collectd.d/10-ethstat.conf')
    end
    it { is_expected.to contain_file('ethstat.load').with_content(%r{^<Plugin ethstat>$}) }
    it { is_expected.to contain_file('ethstat.load').with_content(%r{^  Interface "eth0"$}) }
    it { is_expected.to contain_file('ethstat.load').with_content(%r{^  Interface "eth1"$}) }
    it { is_expected.to contain_file('ethstat.load').with_content(%r{^  Map "rx_csum_offload_errors" "if_rx_errors" checksum_offload"$}) }
    it { is_expected.to contain_file('ethstat.load').with_content(%r{^  Map "multicast" "if_multicast"$}) }
    it { is_expected.to contain_file('ethstat.load').with_content(%r{^  MappedOnly false$}) }
  end

  context ':ensure => absent' do
    let :params do
      { maps: ['"rx_csum_offload_errors" "if_rx_errors" checksum_offload"', '"multicast" "if_multicast"'], ensure: 'absent' }
    end
    it 'Will not create /etc/collectd.d/10-ethstat.conf' do
      is_expected.to contain_file('ethstat.load').with(ensure: 'absent',
                                                       path: '/etc/collectd.d/10-ethstat.conf')
    end
  end

  context ':interfaces is not an array' do
    let :params do
      { interfaces: 'eth0,eth1' }
    end
    it 'Will raise an error about :interfaces being a String' do
      is_expected.to compile.and_raise_error(%r{String})
    end
  end

  context ':maps is not an array' do
    let :params do
      { maps: '"rx_csum_offload_errors" "if_rx_errors" checksum_offload"' }
    end
    it 'Will raise an error about :maps being a String' do
      is_expected.to compile.and_raise_error(%r{String})
    end
  end
end

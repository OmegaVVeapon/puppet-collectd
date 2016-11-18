require 'spec_helper'

describe 'collectd::typesdbconfig', type: :define do
  let :facts do
    {
      osfamily: 'Debian',
      id: 'root',
      concat_basedir: '/dne',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      collectd_version: '4.8.0'
    }
  end

  context 'without the TypesDB directive' do
    let(:title) { '/etc/collectd/custom.db' }
    let(:params) { {'config_file' => '/etc/collectd/collectd.conf' } }

    it 'contains augeas creation of TypesDB directive' do
      is_expected.to contain_augeas('TypesDB directive').with(
        :context => "/files/etc/collectd/collectd.conf/",
        :changes => 'set directive[last()+1] TypesDB',
        :onlyif  => "get directive[. = 'TypesDB'] != TypesDB"
      )
    end

    it 'contains augeas creation of new TypesDB entry' do
      is_expected.to contain_augeas('/etc/collectd/custom.db').with(
        :context => "/files/etc/collectd/collectd.conf/",
        :changes => "set directive[. = \'TypesDB\']/arg[last()+1] '\"/etc/collectd/custom.db\"'",
        :onlyif  => "get directive/value[. = \'TypesDB\'] != '\"/etc/collectd/custom.db\"'",
      )
    end
  end
end

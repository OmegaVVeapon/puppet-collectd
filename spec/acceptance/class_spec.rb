require 'spec_helper_acceptance'

describe 'collectd class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'works idempotently with no errors' do
      pp = <<-EOS
      class { 'collectd': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('collectd') do
      it { is_expected.to be_installed }
    end

    describe service('collectd') do
      it { is_expected.to be_running }
    end
  end

  context 'install memory plugin' do
    it 'works idempotently' do
      pp = <<-EOS
      class { '::collectd': }

      class { '::collectd::plugin::memory': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  context 'add TypesDB to collectd.conf' do
    it 'works idempotently' do
      pp = <<-EOS
      class { '::collectd':
        purge_config => true,
        typesdb => ["/path/to/types.db"],
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
    
    describe file('/etc/collectd.conf') do
      its(:content) { should match (/^TypesDB "\/path\/to\/types.db"/) }
    end

    describe service('collectd') do
      it { is_expected.to be_running }
    end
  end
end

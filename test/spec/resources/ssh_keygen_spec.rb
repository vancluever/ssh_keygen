require 'spec_helper'

describe SSHKeygen::Resource do
  step_into(:ssh_keygen)

  context 'base tests without passphrase' do
    recipe do
      ssh_keygen '/root/.ssh/id_rsa' do
        action :create
        secure_directory true
      end
    end

    it { is_expected.to create_file('/root/.ssh/id_rsa') }

    it 'creates a file at /root/.ssh/id_rsa with the proper permissions' do
      expect(chef_run).to create_file('/root/.ssh/id_rsa').with(
        user:   'root',
        group:  'root',
        mode:   0600
      )
    end

    it 'creates a file at /root/.ssh/id_rsa.pub with the proper permissions' do
      expect(chef_run).to create_file('/root/.ssh/id_rsa.pub').with(
        user:   'root',
        group:  'root',
        mode:   0600
      )
    end

    it 'secures the /root/.ssh directory' do
      expect(chef_run).to create_directory('/root/.ssh').with(
        user:   'root',
        group:  'root',
        mode:   0700
      )
    end
  end

  context 'passphrase-specific tests' do
    recipe do
      ssh_keygen '/root/.ssh/id_rsa_encrypted' do
        action :create
        passphrase 'ilikerandompasswordsbutthiswilldo'
      end
    end

    it 'creates a file at /root/.ssh/id_rsa_encrypted with the proper permissions' do
      expect(chef_run).to create_file('/root/.ssh/id_rsa_encrypted').with(
        user:   'root',
        group:  'root',
        mode:   0600
      )
    end

    it 'creates a file at /root/.ssh/id_rsa_encrypted.pub with the proper permissions' do
      expect(chef_run).to create_file('/root/.ssh/id_rsa_encrypted.pub').with(
        user:   'root',
        group:  'root',
        mode:   0600
      )
    end
  end
end

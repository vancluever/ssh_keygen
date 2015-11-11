require_relative '../spec_helper'

describe SSHKeygen::Resource do
  step_into(:ssh_keygen)
  step_into(:chef_gem)
  recipe do
    ssh_keygen '/root/.ssh/id_rsa' do
      action :create
    end

    # ssh_keygen '/root/.ssh/id_rsa_encrypted' do
    #   action :create
    #   passphrase 'ilikerandompasswordsbutthiswilldo'
    # end
  end

  it { is_expected.to create_file('/root/.ssh/id_rsa') }

  # it 'installs the sshkey gem thru chef_gem' do
  #   expect(chef_run).to install_chef_gem('sshkey')
  # end
  #
  # it 'creates a file at /root/.ssh/id_rsa with the proper permissions' do
  #   expect(chef_run).to create_file('/root/.ssh/id_rsa').with(
  #     user:   'root',
  #     group:  'root',
  #     mode:   0600
  #   )
  # end
  #
  # it 'creates a file at /root/.ssh/id_rsa.pub with the proper permissions' do
  #   expect(chef_run).to create_file('/root/.ssh/id_rsa.pub').with(
  #     user:   'root',
  #     group:  'root',
  #     mode:   0600
  #   )
  # end
  #
  # it 'creates a file at /root/.ssh/id_rsa_encrypted with the proper permissions' do
  #   expect(chef_run).to create_file('/root/.ssh/id_rsa_encrypted').with(
  #     user:   'root',
  #     group:  'root',
  #     mode:   0600
  #   )
  # end
  #
  # it 'creates a file at /root/.ssh/id_rsa_encrypted with the proper permissions' do
  #   expect(chef_run).to create_file('/root/.ssh/id_rsa_encrypted.pub').with(
  #     user:   'root',
  #     group:  'root',
  #     mode:   0600
  #   )
  # end
  #
  # it 'secures the /root/.ssh directory' do
  #   expect(chef_run).to create_directory('/root/.ssh').with(
  #     user:   'root',
  #     group:  'root',
  #     mode:   0700
  #   )
  # end
end

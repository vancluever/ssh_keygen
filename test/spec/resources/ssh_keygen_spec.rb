# Copyright 2015 Chris Marchesi
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'

describe SSHKeygen::Generator do
  context 'default options with a bit strength of 2048' do
    key = ::SSHKeygen::Generator.new(2048, 'rsa', nil, 'test@rspec')

    it 'has a valid PEM-encoded private key' do
      generator_key_digest = key.key_fingerprint
      validator_key_digest = create_fingerprint_from_key(key.private_key)

      expect(generator_key_digest).to eq(validator_key_digest)
    end

    it 'has a valid OpenSSH-style formatted-public key' do
      expect(key.ssh_public_key).to match(%r{^ssh-rsa [a-zA-Z0-9=/+]+ test@rspec})
    end

    it 'has a valid public key for the private key' do
      generator_key_digest = key.key_fingerprint
      public_key = key.ssh_public_key.split(' ')[1]
      public_key_digest = create_fingerprint_from_key(Base64.strict_decode64(public_key))

      expect(generator_key_digest).to eq(public_key_digest)
    end
  end

  context 'with passphrase and a bit strength of 2048' do
    key = ::SSHKeygen::Generator.new(2048, 'rsa', 'onetwothreefour', 'test@rspec')

    it 'has a valid PEM-encoded private key' do
      generator_key_digest = key.key_fingerprint
      validator_key_digest = create_fingerprint_from_key(key.private_key, 'onetwothreefour')

      expect(generator_key_digest).to eq(validator_key_digest)
    end

    it 'has a valid OpenSSH-style formatted-public key' do
      expect(key.ssh_public_key).to match(%r{^ssh-rsa [a-zA-Z0-9=/+]+ test@rspec})
    end

    it 'has a valid public key for the private key' do
      generator_key_digest = key.key_fingerprint
      public_key = key.ssh_public_key.split(' ')[1]
      public_key_digest = create_fingerprint_from_key(Base64.strict_decode64(public_key))

      expect(generator_key_digest).to eq(public_key_digest)
    end
  end
end

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

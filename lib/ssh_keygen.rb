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

require 'poise'
require 'chef/resource'
require 'chef/provider'
require 'ssh_keygen/provider'

# resource and provider classes for the ssh_keygen Chef resource
module SSHKeygen
  # resource class for ssh_keygen resource
  class Resource < Chef::Resource
    include Poise
    provides(:ssh_keygen)
    actions(:create)
    Poise::Helpers::ChefspecMatchers.create_matcher(:ssh_keygen, :create)

    attribute(:path, kind_of: String, name_attribute: true)
    attribute(:owner, kind_of: String, default: 'root')
    attribute(:group, kind_of: String, default: lazy { owner })
    attribute(:strength, equal_to: [2048, 4096], default: 2048)
    # future proofing - but RSA only for now
    attribute(:type, equal_to: ['rsa'], default: 'rsa')
    attribute(:comment, kind_of: String, default: lazy { "#{owner}@#{node['hostname']}" })
    attribute(:passphrase, kind_of: String, default: nil)
    attribute(:secure_directory, kind_of: TrueClass, default: nil)
  end

  # provider class for ssh_keygen resource
  class Provider < Chef::Provider
    include Poise
    include SSHKeygen::SSHKeygenProvider
    provides(:ssh_keygen)

    def action_create
      # load_sshkey_gem
      notifying_block do
        unless ::File.exist?(@new_resource.path)
          create_key
          save_private_key
          save_public_key
          update_directory_permissions
          new_resource.updated_by_last_action(true)
        end
      end
    end
  end
end

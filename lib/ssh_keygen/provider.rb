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

require 'sshkey'

module SSHKeygen
  # provider fucntions for the SSHKeygen Chef resoruce provider class
  module SSHKeygenProvider
    def load_sshkey_gem
      chefgem_context = Chef::RunContext.new(Chef::Node.new, {}, Chef::EventDispatch::Dispatcher.new)
      chefgem_resource = Chef::Resource::ChefGem.new('sshkey', chefgem_context)
      chefgem_resource.run_action(:install)
      require 'sshkey'
    end

    def create_key
      converge_by("Create SSH #{@new_resource.type} #{@new_resource.strength}-bit key (#{@new_resource.comment})") do
        @key = ::SSHKey.generate(
          type: @new_resource.type.upcase,
          bits: @new_resource.strength,
          comment: @new_resource.comment,
          passphrase: @new_resource.passphrase
        )
      end
    end

    def save_private_key
      converge_by("Create SSH private key at #{@new_resource.path}") do
        file @new_resource.path do
          action :create
          owner @new_resource.owner
          group @new_resource.group
          content @key.private_key
          mode 0600
        end
      end
    end

    def save_public_key
      converge_by("Create SSH public key at #{@new_resource.path}") do
        file "#{@new_resource.path}.pub" do
          action :create
          owner @new_resource.owner
          group @new_resource.group
          content @key.public_key
          mode 0600
        end
      end
    end

    def update_directory_permissions
      return false unless @new_resource.secure_directory
      converge_by("Update directory permissions at #{File.dirname(@new_resource.path)}") do
        directory ::File.dirname(@new_resource.path) do
          action :create
          owner @new_resource.owner
          group @new_resource.group
          mode 0700
        end
      end
    end
  end
end

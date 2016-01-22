[![Cookbook Version](https://img.shields.io/cookbook/v/ssh_keygen.svg)](https://supermarket.chef.io/cookbooks/ssh_keygen)

# ssh_keygen Chef Resource

This single-purpose cookbook provides a resource to create SSH keys, as you
would expect to be created with `ssh-keygen`.

## Usage and Example

Say you wanted to create a user (named after `test-kitchen`) and create an
SSH key for it:

```
group 'kitchen' do
  action :create
end

user 'kitchen' do
  action :create
  group 'kitchen'
  home '/home/kitchen'
  manage_home true
end

directory '/home/kitchen/.ssh' do
  action :create
end

ssh_keygen '/home/kitchen/.ssh/id_rsa' do
  action :create
  owner 'kitchen'
  group 'kitchen'
  strength 4096
  type 'rsa'
  comment 'kitchen@localhost'
  passphrase 'changeme'
  secure_directory true
end
```

The following would (after creating the `kitchen` user), generate an SSH private
key in `/home/kitchen/.ssh/id_rsa`, a public key in OpenSSH format in
`/home/kitchen/.ssh/id_rsa.pub`, and ensure the `.ssh` directory has secure
permissions as well (so mode `0700`).

### Attributes

The attributes for the `ssh_keygen` resource are:

 * `action`: Only `:create` is supported.
 * `path`: The path to save the SSH key to (if different from the resource name).
 * `owner`: The owner of the private and public key files.
 * `group`: The group ID for the private and public key files.
 * `strength`: Only `2048` and `4096` are supported currently, default is `2048`.
 * `type`: Only `rsa` is supported currently.
   Ed25519 may be supported in future versions (feature request welcome!)
 * `comment`: Comment for the public key. Defaults to `user@host`.
 * `passphrase`: Passphrase for an encrypted private key. The default is no passphrase.
 * `secure_directory`: Sets the directory the key is saved in to mode to `0700`.

## Author and License

```
Copyright 2015 Chris Marchesi

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

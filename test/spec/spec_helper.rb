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

require 'poise_boiler/spec_helper'
require 'ssh_keygen'

# a small helper function that creates a SHA1 fingerprint from a private key
def create_fingerprint_from_key(key, passphrase = nil)
  new_key = OpenSSL::PKey::RSA.new(key, passphrase)
  new_key_digest = OpenSSL::Digest::SHA1.new(new_key.public_key.to_der).to_s.scan(/../).join(':')
  new_key_digest
end

# a helper function that creates a SHA1 fingerprint from a public key
def create_fingerprint_from_public_key(public_key)
  ::SSHKeygen::PublicKeyReader.new(public_key).key_fingerprint
end

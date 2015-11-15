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

require_relative 'spec_helper'

describe file('/home/kitchen/.ssh/id_rsa') do
  it { should exist }
  it { should be_owned_by 'kitchen' }
  it { should be_grouped_into 'kitchen' }
  it { should be_mode 0600 }
end

# OpenSSL and OpenSSH private keys are the same
describe x509_private_key('/home/kitchen/.ssh/id_rsa') do
  it { should be_valid }
  it { should_not be_encrypted }
end

describe file('/home/kitchen/.ssh/id_rsa.pub') do
  it { should exist }
  it { should be_owned_by 'kitchen' }
  it { should be_grouped_into 'kitchen' }
  it { should be_mode 0600 }
  its(:content) { should match %r{^ssh-rsa [a-zA-Z0-9=/+]+ root@[-_.a-zA-Z0-9]} }
end

describe directory('/home/kitchen/.ssh') do
  it { should exist }
  it { should be_owned_by 'kitchen' }
  it { should be_grouped_into 'kitchen' }
  it { should be_mode 0700 }
end

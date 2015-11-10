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

require 'ssh_keygen/version'

Gem::Specification.new do |spec|
  spec.name = 'ssh_keygen'
  spec.version = SSHKeygen::VERSION
  spec.authors = ['Chris Marchesi']
  spec.email = %w(chrism@vancluevertech.com)
  spec.description = 'Chef resource for SSH key creation'
  spec.summary = spec.description
  spec.homepage = 'https://github.com/vancluever/ssh_keygen'
  spec.license = 'Apache 2.0'

  spec.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_dependency 'halite', '~> 1.0'
  spec.add_dependency 'poise', '~> 2.0'
  spec.add_dependency 'sshkey', '~> 1.7.0'

  spec.add_development_dependency 'kitchen-rackspace', '~> 0.14'
  spec.add_development_dependency 'poise-boiler', '~> 1.0'
end

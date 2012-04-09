#
# Author:: Murali Raju (<murali.raju@.com>)
# Copyright:: Copyright (c) 2011 Murali Raju.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "swift-manager_version"

Gem::Specification.new do |s|
  s.name        = "swift-manager"
  s.version     = SwiftManager::VERSION
  s.authors     = ["Murali Raju"]
  s.email       = ["murali.raju@appliv.com"]
  s.homepage    = "http://github.com/murraju/swift-manager"
  s.summary     = %q{A Ruby OpenStack Swift Client}
  s.description = %q{A Ruby OpenStack Swift Client to create, manage and test Object Storage based on Swift and AWS S3}

  s.rubyforge_project = "swift-manager"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"

  s.add_dependency("gli")
  s.add_dependency("fog")
  s.add_dependency("json")
  s.add_dependency("rainbow")
  s.add_dependency("progress_bar")
  s.add_dependency("terminal-table") 
end
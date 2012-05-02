# Author:: Murali Raju (<murali.raju@appliv.com>)
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

class Parser

	#Parse swift-manager configs (JSON)

	def list_auth_configs
		auth_config_path = Dir.home + "/.swift-manager/authentication/*.json"
		auth_configs = Dir.glob(auth_config_path)

		#Display table output using the terminal-table gem
		table = Terminal::Table.new :headings => ['Auth Config']
		unless auth_configs.empty?
			auth_configs.each do |row|
				@row = []
				@row << "#{File.basename(row, '.*').chomp(File.extname(row))}".bright
				table << @row
			end
		
		end
		puts table.to_s
		puts ''

	end

	def show_auth_config(auth_json)
		auth_config = File.read(Dir.home + "/.swift-manager/authentication/#{auth_json}.json")
		auth_params = JSON.parse(auth_config)

		#Display table output using the terminal-table gem
		table = Terminal::Table.new :headings => [ 'Tag', 'Provider', 'Service', 'Secret Access Key', 'Access Key ID', 'Auth URL']
		auth_params.each do |row|
		  @row = []
		  @row << auth_params["tag"]
		  @row << auth_params["provider"]
		  @row << auth_params["service"]
		  @row << auth_params["keys"]["secret_access_key"]
		  @row << auth_params["keys"]["access_key_id"]
		  @row << auth_params["url"]
		end
		table << @row
		puts table.to_s
		puts ''
	end
end
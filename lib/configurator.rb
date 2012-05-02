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

class Configurator
	
	
	def create_auth_config(auth_hash)
		my_provider = auth_hash[:provider]
		my_service  = auth_hash[:service]
		my_secret_access_key = auth_hash[:secret_access_key]
		my_access_key_id = auth_hash[:access_key_id]
		my_tag = auth_hash[:tag]
		my_auth_url = auth_hash[:url]

      	auth_params = { :provider => my_provider, :service => my_service, :tag => my_tag, :url => my_auth_url,
				        :keys => { :secret_access_key => my_secret_access_key, 
				  	               :access_key_id => my_access_key_id } }

		if File.exists?( File.expand_path "~/.swift-manager/authentication/" )


		    @auth_config_path = Dir.home + "/.swift-manager/authentication/auth_config_#{my_tag}.json"
	      	File.open(@auth_config_path, "w") do |f|        
		        f << JSON.pretty_generate(auth_params)
			end
			
			formatter = Formatter.new
			formatter.print_progress_bar_short

			puts ''
	        puts "Adding authentication info to #{@auth_config_path}".color(:green)
	        puts ''			
		else
			
			puts 'Looks like this is the first time you are running swift-manager. Let\'s setup the env...'.color(:green)
			puts ''
			formatter = Formatter.new
			formatter.print_progress_bar_short

			Dir.mkdir(File.expand_path "~/.swift-manager")
			Dir.mkdir(File.expand_path "~/.swift-manager/authentication")
			Dir.mkdir(File.expand_path "~/.swift-manager/log")
			Dir.mkdir(File.expand_path "~/.swift-manager/shell")

		    @auth_config_path = Dir.home + "/.swift-manager/authentication/auth_config_#{my_tag}.json"

	      	File.open(@auth_config_path, "w") do |f|
		        f << JSON.pretty_generate(auth_params)
			end
			puts ''
			puts "Adding authentication info to #{@auth_config_path}".color(:green)
			puts ''
		end
	end
end
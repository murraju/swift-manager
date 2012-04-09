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

class SwiftClient

	def initialize(type, auth_json)
		auth_config = File.read(Dir.home + "/.swift-manager/authentication/#{auth_json}.json")
		@auth_params = JSON.parse(auth_config)

		case type
		when 's3'
			provider = @auth_params["provider"]
			aws_secret_access_key = @auth_params["keys"]["secret_access_key"]
			aws_access_key_id = @auth_params["keys"]["access_key_id"]
			begin
				puts 'Connecting to OpenStack Swift: S3 middleware...'.color(:green)
				puts ''
				@connection = Fog::Storage.new(	:provider => provider, 
												:aws_secret_access_key => aws_secret_access_key, 
												:aws_access_key_id => aws_access_key_id	)
			
			rescue Exception => e
				raise 'Unable to connect to OpenStack Swift: S3 middleware. Check authentication information or if the service is running'
			end

		when 'swift'
			provider = @auth_params["provider"]			
			swift_api_key = @auth_params["keys"]["secret_access_key"]
			swift_username = @auth_params["keys"]["access_key_id"]
			swift_auth_ip = @auth_params["url_ip"]

			begin
			Excon.defaults[:ssl_verify_peer] = false #SSL verify error on Mac OS X	
			puts 'Connecting to OpenStack Swift...'.color(:green)
			puts ''
			@connection = Fog::Storage.new({	:provider => provider,
												:rackspace_username => swift_username,
												:rackspace_api_key => swift_api_key,
												:rackspace_auth_url => "#{swift_auth_ip}:8080/auth/v1.0"})

			@cdn_connection = Fog::CDN.new({	:provider => provider,
												:rackspace_username => swift_username,
												:rackspace_api_key => swift_api_key,
												:rackspace_auth_url => "#{swift_auth_ip}:8080/auth/v1.0"}) 			

			rescue Exception => e
				raise 'Unable to connect to OpenStack Swift. Check authentication information or if the service is running.'
			end						
		end
	end


	def list_containers
	 	@connection.directories.table
	end

	def create_container_no_cdn(prefix)
		@connection.directories.create(
					:key    => "#{prefix}-#{Time.now.to_i}", # globally unique name
					:public => false,
					:cdn => ""
		)
		sleep 1	
		list_containers
		puts ''
	end

	def create_containers_no_cdn(prefix, number_of)
		start_time = Time.now.to_f
		@count = 1
		number_of.times do
			create_container_no_cdn(prefix)
			end_time = Time.now.to_f
			time_elapsed = end_time - start_time
			puts "Time elapsed to create #{@count} containers: #{time_elapsed} seconds".bright
			@count += 1			
		end
	end

	def delete_container(prefix)
		begin
			puts "Deleting container #{prefix}...".color(:green)
			@connection.directories.get(prefix).destroy
    		puts ''
		rescue Exception => e
			#Fog related bugs...tbd
			#raise 'Delete files first or check if the container lists using \'swift-manager list storage -t swift -f <auth> -i container\''
		end
	end

	def delete_containers
		containers_json = @connection.directories.to_json
		containers = JSON.parse(containers_json)

		container_names = []
		containers.length.times do |i|
			container_names << containers[i]['key']
		end
		start_time = Time.now.to_f
		container_names.each do |container|
			delete_files(container)
			delete_container(container)
			end_time = Time.now.to_f
			@time_elapsed = end_time - start_time
		end
		puts ''
		puts "Time elapsed to delete #{containers.length} containers: #{@time_elapsed} seconds".bright
		puts ''
	end

	def create_files(path_to_local_files, container)
		directory = @connection.directories.get(container)
		files = Dir[path_to_local_files]
		for file in files do
			name = File.basename(file)
			begin
				unless directory.files.head(name)
					directory.files.create(:key => name, :body => open(file))
					puts "Uploading file #{name} to #{container}".bright
				else
					puts "File #{name} already exists. Please delete file and try again".bright
				end
			rescue Exception => e
				raise "Container #{container} does not exist. Please check and try again"
			end

		end
		puts ''
		puts 'Upload complete'.color(:green)
		puts ''
	end

	def list_files(container_name)
		@connection.directories.get(container_name).files.table([:key, :last_modified, :content_length])			
	end

	def delete_files(container)

	    directory = @connection.directories.get(container)
	    files = directory.files
	    files.each do |f|
			f.destroy
	    end
		puts ''
		puts "*Deleting all files in container #{container}".bright
	end

	def generate_json_output
		container_json_path = Dir.home + "/.swift-manager/shell/container.json"
		files_json_path 	= Dir.home + "/.swift-manager/shell/files.json"

		File.open(container_json_path, "w") do |f|        
		    f << @connection.directories.to_json
		end
	end	


end
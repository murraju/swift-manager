#
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


class CloudShell

	#A basic read-only shell-like interface for browsing S3 or Swift JSON objects via fog.to_json using readline

	def run(json_file)
	  root = JSON.parse(json_file)
	  command = nil

	  current_context = Context.new(root,nil)

	  Readline.completion_proc = proc { |input|
    	current_context.completions(input)
  	  }

	  while command != 'exit'
	    command = Readline.readline("swift> ",true)
	    break if command.nil?
	    current_context = execute_command(command.strip,current_context)
	  end
	end


	def execute_command(command,current_context)
	  case command
	  when /^ls$/
	    puts current_context.to_s
	  when /^cd (.*$)/
	    new_context = current_context.cd($1)
	    if new_context.nil?
	      puts "No such key #{$1}"
	    else
	      current_context = new_context
	    end
	  when /^cat (.*)$/
	    item = current_context.cat($1)
	    if item.nil?
	      puts "No such item #{$1}"
	    else
	      puts item.inspect
	    end
	  when /^help$/
	    puts "cat <item> - print the contents of <item> in the current context"
	    puts "cd  <item> - change context to the context of <item>"
	    puts "cd  ..     - change up one level"
	    puts "ls         - list available items in the current context"
	    puts "exit	   - exit shell"
	  end
	  current_context
	end

	class Context
	  attr_reader :here
	  attr_reader :parent_context

	  def initialize(here,parent_context)
	    @here = here
	    @parent_context = parent_context
	  end

	  def completions(input)
    	self.to_s.split(/\s+/).grep(/^#{input}/)
  	  end

	  def cat(path)
	    item_at(path)
	  end

	  def cd(path)
	    if path == '..'
	      self.parent_context
	    else
	      item = item_at(path)
	      if item.nil?
	        nil
	      else
	        Context.new(item,self)
	      end
	    end
	  end

	  def to_s
	    if self.here.kind_of? Array
	      indices = []
	      self.here.each_index { |i| indices << i }
	      indices.join(' ')
	    elsif self.here.kind_of? Hash
	      self.here.keys.join(' ')
	    else
	      self.here.to_s
	    end
	  end

	  private 
	  
	  def item_at(path)
	    if path == '..'
	      self.parent_context.here
	    elsif self.here.kind_of? Array
	      self.here[path.to_i]
	    elsif self.here.kind_of? Hash
	      self.here[path]
	    else
	      nil
	    end
	  end
	end

end
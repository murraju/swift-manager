
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



class Formatter

	def print_progress_bar_long
		puts ''
        bar = ProgressBar.new
		    100.times do
		      sleep 0.075
		  	  bar.increment!
			end
		puts ''
	end

	def print_progress_bar_short
		puts ''
        bar = ProgressBar.new
	    100.times do
	      sleep 0.0055
	  	  bar.increment!
		end
		puts ''		
	end
end
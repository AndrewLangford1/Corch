module Docker
	class File
		def initialize params
			@template = params
		end
		def generate_file
			@dockerfile = "FROM #{@template["docker_params"]["registry"]}/#{@template["base_image"]}/#{@template["runtime"]} \n"
			case @template["base_image"]
			when "ubuntu"
				case @template["runtime"]
				when "ruby"
					@dockerfile << "RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \n"
					@dockerfile << "RUN \curl -sSL https://get.rvm.io | bash -s stable --ruby \n"
					@dockerfile << "RUN gem install bundler \n"
					@dockerfile << "RUN bundle install \n"
				when "node"
					@dockerfile << "RUN mkdir /var/www \n"
					@dockerfile << "ADD . /var/www/ \n"
					@dockerfile << "WORKDIR /var/www \n"
					@dockerfile << "RUN npm install \n"
					@dockerfile << "EXPOSE #{@template["port"]} \n "
					@dockerfile << "CMD [\"node\", \"#{@template["exec_file"]}\"]"
				end
			when "centos"
				puts "CENTOS"
				case @template["runtime"]
				when "ruby"

				when "node"
					@dockerfile << "RUN mkdir /var/www \n"
					@dockerfile << "ADD . /var/www/ \n"
					@dockerfile << "WORKDIR /var/www \n"
					@dockerfile << "RUN npm install \n"
					@dockerfile << "EXPOSE #{@template["port"]} \n "
					@dockerfile << "CMD [\"node\", \"#{@template["exec_file"]}\"]"
				end
			end
			puts "#{@dockerfile}"
			return @dockerfile
		end
	end
end
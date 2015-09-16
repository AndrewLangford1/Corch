require 'tempfile'
module Docker
	class Dockerfile
		def initialize params
			@template = params
		end
		def generate_file
			puts "==> Generating Dockerfile for this project"
			begin
				@dockerfile = Tempfile.new "Dockerfile"
				##BUILD DOCKERFILE
				content = "FROM #{@template["docker_params"]["registry"]}/#{@template["base_image"]}/#{@template["runtime"]} \n"
				case @template["base_image"]
				when "ubuntu"
					case @template["runtime"]
					when "ruby"
						content << "RUN mkdir /app \n"
						content << "ADD . /app \n"
						content << "WORKDIR /app \n"
						content << "RUN bundle install \n"
						content << "CMD [\"rake\", \"run\"]"
					when "node"
						content << "RUN mkdir /app \n"
						content << "ADD . /app/ \n"
						content << "WORKDIR /app \n"
						content << "RUN npm install \n"
						content << "EXPOSE #{@template["port"]} \n "
						content << "CMD [\"node\", \"#{@template["exec_file"]}\"]"
					end
				when "centos"
					puts "CENTOS"
					case @template["runtime"]
					when "ruby"
						content << "RUN mkdir /app \n"
						content << "ADD . /app \n"
						content << "WORKDIR /app \n"
						content << "RUN bundle install \n"
						content << "CMD [\"rake\", \"run\"]"

					when "node"
						content << "RUN mkdir /app \n"
						content << "ADD . /app \n"
						content << "WORKDIR /app \n"
						content << "RUN npm install \n"
						content << "EXPOSE #{@template["port"]} \n "
						content << "CMD [\"node\", \"#{@template["exec_file"]}\"]"
					end
				end
				#write content to file
				@dockerfile.write content
				@dockerfile.rewind
				#return file as as a string
				ret = @dockerfile.read
				@dockerfile.close
				return ret
			rescue Exception => e 
				puts e
				puts e.backtrace
				return nil
			end
		end
	end
end
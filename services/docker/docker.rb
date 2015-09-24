#module wrapper for Docker service
module Docker
	#class to generate dockerfiles for CICD
	class Dockerfile
		#base contstructor
		def initialize params
			@template = params
		end
		#generates a dockerfile (in docstring type) for:
		#supported runtimes: ruby, nodejs
		#supported OS: centos, ubuntu
		#TODO support middleware
		def generate_file
			puts "==> Generating Dockerfile for this project"
			begin
				##BUILD DOCKERFILE
				case @template["base_image"]
				when "ubuntu"
					case @template["runtime"]
					when "ruby"
						return <<-DOCKERFILE
						FROM #{@template["docker_params"]["registry"]}/#{@template["base_image"]}/#{@template["runtime"]} \n
						RUN mkdir /app \n
						ADD . /app \n
						WORKDIR /app \n
						RUN bundle install \n
						CMD [\"rake\", \"run\"] 
						DOCKERFILE
					when "node"
						return  <<-DOCKERFILE
						FROM #{@template["docker_params"]["registry"]}/#{@template["base_image"]}/#{@template["runtime"]} \n
						RUN mkdir /app \n
						ADD . /app/ \n
						WORKDIR /app \n
						RUN npm install \n
						EXPOSE #{@template["port"]} \n "
						CMD [\"node\", \"#{@template["exec_file"]}\"]
						DOCKERFILE
					end
				when "centos"
					case @template["runtime"]
					when "ruby"
						return <<-DOCKERFILE
						FROM #{@template["docker_params"]["registry"]}/#{@template["base_image"]}/#{@template["runtime"]} \n
						RUN mkdir /app \n
						ADD . /app \n
						WORKDIR /app \n
						RUN bundle install \n
						CMD [\"rake\", \"run\"]
						DOCKERFILE
					when "node"
						return <<-DOCKERFILE
						FROM #{@template["docker_params"]["registry"]}/#{@template["base_image"]}/#{@template["runtime"]} \n
						RUN mkdir /app \n
						ADD . /app \n
						WORKDIR /app \n
						RUN npm install \n
						EXPOSE #{@template["port"]} \n 
						CMD [\"node\", \"#{@template["exec_file"]}\"]
						DOCKERFILE
					end
				end
			rescue Exception => e 
				puts e
				puts e.backtrace
				return nil
			end
		end
	end
end
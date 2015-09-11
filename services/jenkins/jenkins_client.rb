require 'rest-client'
require 'json'
#Module concerning the Jenkins Service
module Jenkins
	#Class to interact with the jenkins api
	class Client
		def initialize params
			@jenkins_host = params["jenkins_host"]
			@jenkins_port = params["jenkins_port"]
			puts "==> Initializing Jenkins Client at #{@jenkins_host}:#{@jenkins_port}"
		end
		#creates a new job 
		#@param xml => the config.xml file for the job
		#@param name => the name of the job
		#@return => string, the response code of the request, 200 is successful, 500 if not
		def create_job xml, name
			puts "==> Creating job for project: '#{name}'"
			begin
				create_response = RestClient.post "#{@jenkins_host}:#{@jenkins_port}/createItem/?name=#{name}", xml , {:content_type => :xml}
				return create_response.code.to_s
			rescue Exception => e
				puts "==> Error creating job #{name}"
				return "500"
			end
		end
		#builds the specified job
		#@param name => the name of the job to build
		#@return => string, the response code of the request, 201 is successful, 500 if not
		def build_job name
			puts "==> Building job for project: '#{name}'"
			begin 
				build_response = RestClient.get "#{@jenkins_host}:#{@jenkins_port}/job/#{name}/build?delay=0sec"
				return build_response.code.to_s
			rescue Exception => e
				puts "==> Error Building job '#{name}'"
				return "500"
			end
		end
		#pull specified job config.xml
		#@param name, the name of the job 
		#@return success status, and job config.xml (if successful)
		def get_job name
			puts "==> Pulling config.xml for job: '#{name}'"
			ret = {}
			begin
				response = RestClient.get "#{@jenkins_host}:#{@jenkins_port}/job/#{name}/config.xml"
				if response.code == 200
					ret[:success] = true
					ret[:job] = response.body
				else
					raise '==> Job does not exist'
				end
			rescue Exception => e
				puts e
				ret[:success] = false
			end
			return ret
		end
		#Tests whether or not the specified job exists
		#@param name the job name
		#@returns true if job exists, false otherwise
		def job_exists? name
			job = get_job name
			return job[:success]
		end
		#delete the specified job
		#@param name the job name
		#@returns true if the job successfully deleted, false otherwise
		def delete_job name
			puts "==> Deleting job: '#{name}'"
			RestClient.post("#{@jenkins_host}:#{@jenkins_port}/job/#{name}/doDelete", {}){ |response, request, result, &block|
				if [301, 302, 307].include? response.code
   					response.follow_redirection(request, result, &block)
  				else
    				response.return!(request, result, &block)
  				end
  			}
  			return true
		end
	end
end
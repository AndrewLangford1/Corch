require 'rest-client'

#Module concerning the Jenkins Service
module Jenkins
	#Class to interact with the jenkins api
	class Client

		def initialize params
			@jenkins_host = params[:jenkins_host]
			@jenkins_port = params[:jenkins_port]
			#todo authentication params
		end
		#creates a new job 
		#@param xml => the config.xml file for the job
		#@param name => the name of the job
		#@return => the response code of the request, 200 is successful
		def create_job xml, name
			create_response = RestClient.post "#{@jenkins_host}:#{@jenkins_port}/createItem/?name=#{name}", xml , {:content_type => :xml}
			return create_response.code
		end

		#builds the specified job
		#@param name => the name of the job to build
		#@return => the response code of the request, 200 is successful
		def build_job name
			build_response = RestClient.get "#{@jenkins_host}:#{@jenkins_port}/job/#{name}/build?delay=0sec"
			return build_response.code
		end
	end
end
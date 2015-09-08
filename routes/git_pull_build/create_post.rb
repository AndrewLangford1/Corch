require 'rest-client'
require 'json/pure'
require 'sinatra/cross_origin'

require_relative '../../utils/XML_Gen.rb'
require_relative '../../services/jenkins/jenkins_client.rb'

#@TODO fix the configuration for this, shouldnt have two seperate configurations and shouldnt have to merge

#Route to create a new freestyle project.
#Pulls code repo from github and builds project.
post '/create_fs' do
 	#get params from UI
	request_params = JSON.parse(request.body.read)

	puts "#{request_params}"
	#docker configuration params, SHOULDNT HAVE TO MERGE THIS HASH FIND A BETTER WAY
	config_params = {"docker_params" => settings.docker_config}.merge request_params
	#generate xml from the templates
	xml_gen = Utils::XML_Gen.new config_params
	config_xml = xml_gen.build_config
	#returnable
	ret = {:success => false}
	#Begin git pull code and build
	begin
		#create jenkins client
		jenkins = Jenkins::Client.new settings.jenkins_config
		#if job already exists, delete old confid and replace with newly generated
		if jenkins.job_exists? request_params["name"]
			successful = jenkins.delete_job request_params["name"]
			unless successful
				return ret.to_json
			end
		end
		#create job
		ret[:create_job_code] = jenkins.create_job config_xml, request_params["name"]
		#build job
		ret[:build_code] = jenkins.build_job request_params["name"]
		#if we get here, op was successful
		ret[:success] = true
	#really basic error handling
	rescue Exception => e
		puts e
		puts e.backtrace
	end
	#return ret hash in json form
	return ret.to_json
end

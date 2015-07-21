require 'rest-client'
require 'json/pure'
require 'sinatra/cross_origin'

require_relative '../../utils/xml_gen/XML_Templates.rb'
require_relative '../../services/jenkins/jenkins_client.rb'

#Route to create a new freestyle project.
#Pulls code repo from github and builds project.
post '/create_fs' do
 	#get params from UI
	params = JSON.parse(request.body.read)
	#generate xml from the templates
	config_xml = XML_Templates.git_pull_and_build(params["git_url"])

	ret = {:success => false}

	#Begin git pull code and build
	begin
		#create jenkins client
		jenkins = Jenkins::Client.new settings.jenkins_config
		#create job
		ret[:create_job_code] = jenkins.create_job config_xml, params["name"]
		#build job
		ret[:build_code] = jenkins.build_job params["name"]
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

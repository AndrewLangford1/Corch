require 'rest-client'
require 'json/pure'

require_relative '../../utils/xml_gen/XML_Templates.rb'
require_relative '../../services/jenkins/jenkins_client.rb'




 post '/create_fs' do
 	 #get params from UI
	params = JSON.parse(request.body.read)
	#generate xml from the templates
	config_xml = XML_Templates.git_pull_and_build(params["git_url"])
	begin
		jenkins = Jenkins::Client.new settings.jenkins_config
		#return object
 		ret = {:success => false}
		#create job
		ret[:create_job_code] = jenkins.create_job config_xml, params["name"]
		#build job
		ret[:build_code] = jenkins.build_job params["name"]
		#if we get here, op was successful
		ret[:success] = true
	rescue Exception => e
		puts e
		puts e.backtrace
		return "ERROR: #{ret}"	
	end

	return "#{ret}"
end

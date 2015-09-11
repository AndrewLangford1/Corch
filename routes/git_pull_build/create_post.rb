require 'rest-client'
require 'json/pure'
require 'sinatra/cross_origin'
require_relative '../../utils/XML_Gen.rb'
require_relative '../../services/jenkins/jenkins_client.rb'
require_relative '../../services/docker/docker.rb'
#Route to create a new freestyle project.
#Pulls code repo from github and builds project.
post '/create_fs' do
	begin
	 	#job configuration hash
		config_params = {"docker_params" => settings.docker_config, "jenkins_params" => settings.jenkins_config}.merge!(JSON.parse(request.body.read))
		#raise error if there are runtimes we dont support yet
		raise "Currently only Ruby and Nodejs runtimes are supported" if (config_params["runtime"] == "liberty" || config_params["runtime"] == "python")
		#generate dockerfile
		dockerfile = (Docker::Dockerfile.new config_params).generate_file
		#if dockerfile wasn't generated, raise an error
		raise "Dockerfile couldn't be generated for this project" if dockerfile.nil?
		#add dockerfile to job configuration hash
		config_params.merge!({"dockerfile" => dockerfile})
		#generate xml from the templates
		config_xml = (Utils::XML_Gen.new config_params).build_config
		#if configuration failed, raise error
		raise "Jenkins job configuration XML couldn't be generated for this project" if config_xml.nil?
		#create jenkins client
		jenkins = Jenkins::Client.new settings.jenkins_config
		#if job already exists, delete old confid and replace with newly generated, @TODO could send an update job
		if jenkins.job_exists? config_params["name"]
			deletion_successful = jenkins.delete_job config_params["name"]
			raise "Jenkins job couldn't be updated for this project" if !deletion_successful
		end
		#Create the job and build it
		ret = {:create_job_code => (jenkins.create_job config_xml, config_params["name"]),
			  :build_code => (jenkins.build_job config_params["name"]),
			  :success => true}
		return ret.to_json
	rescue Exception => e
		puts "==> #{e}"
		#puts e.backtrace
		return {:success => false, :message => e}.to_json
	end
end

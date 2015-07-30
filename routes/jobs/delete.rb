require 'rest-client'
require 'json/pure'
require 'sinatra/cross_origin'
require_relative '../../services/jenkins/jenkins_client.rb'

#deletes the specfied job
post '/delete/job/:name' do
	#create jenkins client
	begin 
		jenkins = Jenkins::Client.new settings.jenkins_config
		if jenkins.job_exists? params["name"]
			successful = jenkins.delete_job params["name"]
			return {:success => successful}.to_json
		else
			return {success: false}.to_json
		end
	rescue Exception => e
		puts "Error deleteing job #{name}"
		return {success: false}.to_json
	end
end

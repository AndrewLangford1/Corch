require 'rest-client'
require 'json/pure'
require 'sinatra/cross_origin'
require_relative '../../services/jenkins/jenkins_client.rb'


#gets config.xml for the specified job.
get '/job/:name' do
	begin
		#create jenkins client
		jenkins = Jenkins::Client.new settings.jenkins_config
		#pull job
		job = jenkins.get_job params["name"]
		return job.to_json
	rescue Exception => e
		return {success: false}.to_json
	end
end

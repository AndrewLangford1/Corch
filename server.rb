require 'sinatra'


configure do 
	set :jenkins_config,  {:jenkins_host => "localhost", :jenkins_port => "8080"}
	
end


get '/' do 
	return "Cloud Orchestration Jenkins Automation (Wrapper)"	
end

###ROUTES
require_relative './routes/git_pull_build/create_post.rb'
require_relative './routes/jobs/get_all.rb'








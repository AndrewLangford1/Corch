require 'sinatra'
require'sinatra/cross_origin'

configure do 
	set :jenkins_config,  {:jenkins_host => "localhost", :jenkins_port => "8080"}
	enable :cross_origin
end

get '/' do 
	return "Cloud Orchestration Jenkins Automation"	
end

options "*" do
  response.headers["Allow"] = "HEAD,GET,PUT,DELETE,OPTIONS"

  # Needed for AngularJS
  response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"

end

#################ROUTES###################
require_relative './routes/git_pull_build/create_post.rb'
require_relative './routes/jobs/get_all.rb'








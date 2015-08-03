require 'sinatra'
require'sinatra/cross_origin'
require 'yaml'

#Config settings
configure do 
	set :port, 5000
	set :jenkins_config,  YAML.load_file(File.open('config/jenkins_config.yml'))
	set :docker_config, YAML.load_file(File.open('config/docker_config.yml'))
	enable :cross_origin
end

#Basic route to test connectivity
get '/' do 
	return "Corch: Cloud Orchestration Jenkins Automation. Running on #{settings.bind}:#{settings.port}"	
end


#handles cross reference requests, needed to communicate with angular frontend
options "*" do
 	content_type :json    
   	headers 'Access-Control-Allow-Origin' => '*', 
            'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST'] 
end

################# BEGIN ROUTES ######################
require_relative './routes/git_pull_build/create_post.rb'
require_relative './routes/jobs/show.rb'
require_relative './routes/jobs/delete.rb'










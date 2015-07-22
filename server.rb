require 'sinatra'
require'sinatra/cross_origin'
require 'yaml'

#Config settings
configure do 
	set :jenkins_config,  YAML.load_file(File.open('config/jenkins_config.yml'))
	enable :cross_origin
end

#Basic route to test connectivity
get '/' do 
	return "Corch: Cloud Orchestration Jenkins Automation"	
end


#handles cross reference requests, needed to communicate with angular frontend
options "*" do
 	content_type :json    
   	headers 'Access-Control-Allow-Origin' => '*', 
            'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST'] 
end

################# BEGIN ROUTES ######################
require_relative './routes/git_pull_build/create_post.rb'










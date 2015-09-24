require 'sinatra'
require 'sinatra/base'
require 'sinatra/cross_origin'
require 'yaml'
require 'logger'
#Config settings
configure do
	$stdout.sync = true
	set :port, 5000
	set :config,  YAML.load_file(File.open('config/config.yml'))
	enable :cross_origin

	#Configure Logging
	Dir.mkdir('logs') unless File.exist?('logs')
    $logger = Logger.new('logs/common.log','weekly')
    $logger.level = Logger::WARN
    $stdout.reopen("logs/output.log", "w")
    $stdout.sync = true
    $stderr.reopen($stdout)
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
require_relative './routes/full-cycle.rb'

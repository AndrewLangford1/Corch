require 'sinatra'
require './services/jenkins/jenkins-client.rb'

get '/' do 
	client = Jenkins::Client.new
	puts client.get_all_jobs
	#jobs_list =  client.filter_jobs("HelloWorldContainer")
	#puts jobs_list
	#chain = client.chain_jobs jobs_list
	#puts chain
	#ret = client.trigger_build(chain)
	#ret[:codes].each do |code|
	#	puts code
	#end
end




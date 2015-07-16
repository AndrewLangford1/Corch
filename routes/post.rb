require 'json_pure'

post '/' do 
	build_request = JSON.parse(request.body.read)
	puts "#{build_request}"
end
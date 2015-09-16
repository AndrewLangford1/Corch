require 'yaml'
#utilities module
module Kubernetes
	#class to generate kubernetes configurations
	class Kubernetes_YML_Gen
		def initialize args
			@template = args
		end
		def build_config
			puts "==> Generating Kubernetes configuration yaml"
			begin
				image = "#{@template["docker_params"]["registry"]}/#{@template["base_image"]}/#{@template["runtime"]}_#{@template["name"]}"
				hash = {
					"apiVersion"=> @template["kubernetes"]["api"],
					"id" => @template["name"],
					"kind" => @template["kubernetes"]["kind"],
					"desiredState" => {
						"manifest" => {
							"version" => @template["kubernetes"]["api"],
							"id" => @template["name"],
							"containers" => {
								"name" => @template["name"],
								"image" => image,
								"ports" => {
									"hostPort" => @template["port"].to_i,
									"containerPort" => @template["port"].to_i
								}
							}
						}
					}
				}
				return hash.to_yaml
			rescue Exception => e
				puts e
				puts e.backtrace
				return nil
			end
		end
	end
end
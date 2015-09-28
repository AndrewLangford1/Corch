require 'yaml'
require 'json'
#Kubernetes service module namespace
module Kubernetes
	#class to generate kubernetes configurations
	class Kubernetes_YML_Gen
		#base constructor
		def initialize args
			@template = args
		end
		#generate a kubernetes yaml config files
		def build_kubernetes_config
			begin
				return kubernetes_config = {"pod" => build_pod_yml, "service" => build_service_yml}
			rescue Exception => e
				return nil
			end
		end	
	
		#generate a kubernetes pod yaml config file 	
		#@return a yaml file containing kubernetes configuration
		def build_pod_yml
			puts "==> Generating yaml configuration for #{@template["name"]}-pod"
			image = "#{@template["docker_params"]["registry"]}/#{@template["base_image"]}/#{@template["runtime"]}_#{@template["name"]}"
			pod_hash = {
				"apiVersion"=> @template["kubernetes"]["api"],
				"kind" => @template["kubernetes"]["kind"]["pod"],
				"metadata" => {
					"name" => @template["name"],
					"labels" => {
						"role" => @template["name"]
					}
				},
				"spec" => {
					"containers" => [{
						"name" => @template["name"],
						"image" => image,
						"ports" => [{
							"name" => @template["name"],
							"containerPort" => @template["port"].to_i
						}],
						"securityContext" => {
							"privileged" => true
						}
					}]
				}
			}
			puts "#{pod_hash.to_yaml}"
			return pod_hash.to_yaml
		end
		#generate a kubernetes service yaml config file 	
		#@return a yaml file containing kubernetes configuration
		def build_service_yml
			puts "==> Generating yaml configuration for #{@template["name"]}-service"
			reverse_proxy = {"hosts" => [{"host" => "#{@template["name"]}.default.ciohcld.innovate.ibm.com", "port"=> "80", "path"=> ["/#{@template["name"]}"], "defaultPath"=> "#{@template["name"]}"}]}.to_json
			service_hash = {
				"kind" => @template["kubernetes"]["kind"]["service"],
				"apiVersion" => @template["kubernetes"]["api"],
				"metadata" => {
					"name" => @template["name"],
					"labels" => {
						"name" => @template["name"]
					},
					"annotations" => {
						"kubernetesReverseproxy" => reverse_proxy
					}
				},
				"spec" => {
					"ports" => [{"port" => @template["port"].to_i}],
					"selector" => {
						"role" => @template["name"]
					}
				}
			}
			puts "#{service_hash.to_yaml}"
			return service_hash.to_yaml
		end
	end
end
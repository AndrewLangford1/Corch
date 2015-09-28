#Utiities Module
require 'nokogiri'
module Jenkins
	#class to generate config.xml
	class Jenkins_XML_Gen
		#base constructor
		def initialize params
			@template = params
		end
		#Generates Jenkins config
		def build_config
			puts "==> Generating Jenkins job configuration xml"
			#Awkward xml tags with dots in them that ruby doesn't like:
			hudson_git_plugin = "hudson.plugins.git.UserRemoteConfig"
			hudson_branches = "hudson.plugins.git.BranchSpec"
			hudson_tasks = "hudson.tasks.Shell"
			begin			
				@project = Nokogiri::XML::Builder.new do |xml|
					xml.project{
						xml.actions{
						}
						xml.description{
						}
						xml.keepDependencies false
						xml.properties{
						}
						xml.scm(:class => "hudson.plugins.git.GitSCM", :plugin => "git@2.4.0"){
							xml.configVersion 2
							xml.userRemoteConfigs{
								xml.send(:"#{hudson_git_plugin}"){
									xml.url @template["git_url"]
								}
							}
							xml.branches{
								xml.send(:"#{hudson_branches}"){
									xml.name "*/master"
								}
							}
							xml.doGenerateSubmoduleConfigurations false
							xml.submoduleCfg(:class => "list"){
							}
							xml.extensions{
							}
						}
						xml.canRoam true
						xml.disabled false
						xml.blockBuildWhenDownstreamBuilding false
						xml.blockBuildWhenUpstreamBuilding false
						xml.triggers{
						}
						xml.concurrentBuild false
						xml.builders{
							xml.send(:"#{hudson_tasks}"){
								xml.command generate_build_shell_execution
							}
						}
						xml.buildWrappers{
						}
					}
				end
				return @project.to_xml
			rescue Exception => e 
				puts e
				puts e.backtrace
				return nil
			end
		end

		#BUILD STEPS
		#1: Pull code from Github Repository
		#2: Build new Docker image for the application
		#3: Push new image to private docker registry
		#4: Pull yaml files(s) and execute them 
		#5: (optional: maintenance; update for the app)
		def generate_build_shell_execution
			#current directory in the workspace
			current_directory = "#{@template["jenkins_params"]["jenkins_home"]}/jobs/#{@template["name"]}/workspace"
			#docker image
			image = "#{@template["docker_params"]["registry"]}/#{@template["base_image"]}/#{@template["runtime"]}_#{@template["name"]}"
			#kubernetes yaml
			pod_yaml = "#{@template["name"]}-pod.yml"
			service_yaml = "#{@template["name"]}-service.yml"
			#generate bash script for build execution
			bash_script = <<-BASH 
			cd #{current_directory};
			rm -rf Dockerfile;
			touch Dockerfile;
			echo \'#{@template["dockerfile"]}\' >> Dockerfile;
			rm -rf #{@template["name"]}-pod.yml ;
			touch #{@template["name"]}-pod.yml ;
			echo '#{@template["kubernetes_yaml"]["pod"]}' >> #{@template["name"]}-pod.yml ;
			rm -rf #{@template["name"]}-service.yml ;
			touch #{@template["name"]}-service.yml ;
			echo "#{@template["kubernetes_yaml"]["service"]}" >> #{@template["name"]}-service.yml;
			docker build -t #{image} . ;
			docker push #{image} ;
			kubectl -s #{@template["kubernetes"]["server"]}:#{@template["kubernetes"]["port"]} create -f #{pod_yaml} ;
			kubectl -s #{@template["kubernetes"]["server"]}:#{@template["kubernetes"]["port"]} create -f #{service_yaml} ;
			BASH
			return bash_script
		end
	end
end
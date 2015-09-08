#Utiities Module
require 'nokogiri'
module Utils
	#class to generate config.xml
	class XML_Gen
		#base constructor
		def initialize params
			@template = params
		end
		#Generates Jenkins config
		def build_config
			hudson_git_plugin = "hudson.plugins.git.UserRemoteConfig"
			hudson_branches = "hudson.plugins.git.BranchSpec"
			hudson_tasks = "hudson.tasks.Shell"

			docker_commands = "cd /var/lib/jenkins/jobs/#{@template["name"]}/workspace ;"
			#build image
			docker_commands << "docker build -t #{@template["docker_params"]["registry"]}/#{@template["base_image"]}/#{@template["name"]} . ;"
			#push image
			docker_commands << "docker push #{@template["docker_params"]["registry"]}/#{@template["base_image"]}/#{@template["name"]} ;"
			#run container
			docker_commands << "docker run -d -p 4567:4567 #{@template["docker_params"]["registry"]}/#{@template["base_image"]}/#{@template["name"]} ;"
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
							xml.command docker_commands
						}
					}
					xml.buildWrappers{
					}
				}
			end
			return @project.to_xml
		end
	end
end
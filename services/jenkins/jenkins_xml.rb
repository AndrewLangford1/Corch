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
				#Docker commands we want to run as build steps:
				docker_commands = generate_docker_commands
			
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
			rescue Exception => e 
				puts e
				puts e.backtrace
				return nil
			end
		end
		def generate_docker_commands
			current_directory = "#{@template["jenkins_params"]["jenkins_home"]}/jobs/#{@template["name"]}/workspace"
			docker_commands =  "cd #{current_directory};"
			docker_commands << "rm -rf Dockerfile;"
			docker_commands << "touch Dockerfile;"
			docker_commands << "rm -rf #{@template["name"]}.yml ;"
			docker_commands << "touch #{@template["name"]}.yml ;"
			docker_commands << "echo \'#{@template["kubernetes_yaml"]}\' >> #{@template["name"]}.yml ;"
			docker_commands << "echo \'#{@template["dockerfile"]}\' >> Dockerfile;"
			docker_commands << "docker build -t #{@template["docker_params"]["registry"]}/#{@template["base_image"]}/#{@template["runtime"]}_#{@template["name"]} . ;"
			#docker_commands << "docker push #{@template["docker_params"]["registry"]}/#{@template["base_image"]}/#{@template["runtime"]}_#{@template["name"]} ;"
			docker_commands << "docker run -d -p #{@template["port"]}:#{@template["port"]} #{@template["docker_params"]["registry"]}/#{@template["base_image"]}/#{@template["runtime"]}_#{@template["name"]} ;"
			return docker_commands
		end
	end
end
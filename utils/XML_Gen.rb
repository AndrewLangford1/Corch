#Utiities Module
module Utils

	#class to generate config.xml
	class XML_Gen

		#@TODO
		#base constructor
		def initialize params
			@template = params
			@xml = ""
		end
		
		def build_config
			create_header
			add_scm @template["git_url"]
			add_pre_triggers
			add_triggers @template["triggers"]
			add_concurrent_build
			add_builders
			add_build_wrappers @template["build_wrappers"]
			return close_project
		end

		#basic header, not supporting any sort of description or advanced project options
		def create_header
			@xml << "<project>
						<actions/>
						<description/>
						<keepDependencies>false</keepDependencies>
						<properties/>"
		end

		#Adds a source code management to the job configuration(currently only git supported)
		#currently only pulling from master branch is supported
		def add_scm git_url
		@xml << "<scm class= \"hudson.plugins.git.GitSCM\" plugin=\"git@2.4.0\">
					<configVersion>2</configVersion>
					<userRemoteConfigs>
						<hudson.plugins.git.UserRemoteConfig>
							<url>#{git_url}</url>
						</hudson.plugins.git.UserRemoteConfig>
					</userRemoteConfigs>
					<branches>
						<hudson.plugins.git.BranchSpec>
							<name>*/master</name>
						</hudson.plugins.git.BranchSpec>
					</branches>
					<doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
					<submoduleCfg class=\"list\"/>
					<extensions/>
				</scm>"
		end

		#@TODO
		def add_pre_triggers
			@xml << "	<canRoam>true</canRoam>
						<disabled>false</disabled>
						<blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
						<blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>"
		end

		#@TODO
		def add_triggers triggers
			if triggers

			else
				@xml<< "<triggers/>"
			end
		end

		#@TODO
		def add_concurrent_build
			@xml<<"<concurrentBuild>false</concurrentBuild>"
		end

		def add_builders
			@xml << "<builders>"

			##add other builders here.
			docker_builders

			@xml<<"</builders>"
		end


		def docker_builders
			@xml << "<hudson.tasks.Shell>
						<command>"
			#pull registry
			@xml << "cd /var/lib/jenkins/jobs/#{@template["name"]}/workspace ;"
			#build image
			@xml << "docker build -t #{@template["docker_params"]["registry"]}/#{@template["base_image"]}/#{@template["name"]} . ;"
			#push image
			@xml << "docker push #{@template["docker_params"]["registry"]}/#{@template["base_image"]}/#{@template["name"]} ;"
			#run container
			@xml << "docker run -d -p 4567:4567 #{@template["docker_params"]["registry"]}/#{@template["base_image"]}/#{@template["name"]} ;"
			#close
			@xml << 	"</command>
					</hudson.tasks.Shell>"
					
		end

		def add_build_wrappers wrappers 
			if wrappers
				#add wrapper logic
			else
				@xml<< "<buildWrappers/>"
			end

		end

		#closes project job and returns the xml
		def close_project
			@xml<< 	"</project>"
			return @xml
		end
	end
end
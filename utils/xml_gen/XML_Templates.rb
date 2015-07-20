class XML_Templates
	def self.git_pull_and_build git_url
		xml = "<project>
			   	<actions/>
			   	<description/>
			   	<keepDependencies>false
			   	</keepDependencies>
			   	<properties/>
			   	<scm class= \"hudson.plugins.git.GitSCM\" plugin=\"git@2.4.0\">
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
			   	</scm>
			   	<canRoam>true</canRoam>
			   	<disabled>false</disabled>
			   	<blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
			   	<blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
			   	<triggers/>
			   	<concurrentBuild>false</concurrentBuild>
			   	<builders/>
			   	<publishers/>
			   	<buildWrappers/>
			   	</project>"
		return xml
	end
end
require 'jenkins_api_client'

module Jenkins
	class Client

		attr_accessor :client
		#base constructor
		def initialize
			 @client = JenkinsApi::Client.new YAML.load_file(File.expand_path("../../../config/login.yml", __FILE__))
			 return @client
		end

		#returns a list of all jobs on this jenkins instance.
		def get_all_jobs
			if(@client)
				return @client.job.list_all
			else
				return nil
			end
		end

		#@param regex => the regex to filter by
		#returns a list of filtered jobs
		def filter_jobs regex
			if(@client)
				return @client.job.list(regex)
			else
				return nil
			end
		end

		#chains jobs
		#@param jobs => the list of jobs to chain 
		def chain_jobs jobs
			if(@client)
				return initial_jobs = @client.job.chain(jobs, 'success', ["all"])
			else
				return nil
			end
		end

		#builds all jobs in the job list
		#@param jobs => array of jobs to build
		def trigger_build jobs
			#returnable
			ret = {}
			ret[:codes] = []
			#if client connection is present, build all the jobs
			if(@client)
				jobs.each do |individual|
					ret[:codes] << @client.job.build(individual)
				end
			end

			return ret
		end
	end
end
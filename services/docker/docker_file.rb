module Docker
	class File


		def initialize params
			@template = params
			@dockerfile = File.new("Dockerfile", "w+")
		end

		def declare_base
			case @template["base_image"]
			when "centos"
				

		end

	end


	class SinatraFile < File
		def initialize params
			super(params)
		end
	end
end
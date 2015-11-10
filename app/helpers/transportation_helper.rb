module TransportationHelper

	include HTTParty



	def r2r_call

	  @response = HTTParty.get("http://free.rome2rio.com/api/1.2/json/Search?key=PZgcLuJc&oPos="+@originCoords+"&dPos="+@destinationCoords+"&flags=0x00000002")
	  @routes = @response['routes']

	  @routeLengths = []

	  
	  @routes.each do |route|
	  	@duration = 0
	  	@segmentDuration = 0
		  route['segments'].each do |segment|
		  	if segment['isMajor'] == 1
		  		@duration += segment['duration'].to_i

		  		
		  	end

		  	#segment['durationLength'] = segment['duration'].to_i / @duration 
		  end
		  @routeLengths << @duration.to_i
		  
	
		  if @duration >= @routeLengths.max
		  	@routeLongest = @duration
		  end

		  route['durationMajor'] = @duration.to_i
		  route['durationText'] = minutes_to_hours(@duration)
		end

		puts "*****************duration" + @segmentDuration.to_s



	  @currencyCode = "$"

	end

	def minutes_to_hours(minutes)
		hr = minutes / 60
		min = minutes % 60
		return "#{hr}h #{min}min"  

	end

end

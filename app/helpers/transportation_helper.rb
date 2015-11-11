module TransportationHelper

	include HTTParty



	def r2r_call

	  response = HTTParty.get("http://free.rome2rio.com/api/1.2/json/Search?key=PZgcLuJc&oPos="+@originCoords+"&dPos="+@destinationCoords+"&flags=0x00000002")
	  @routes = response['routes']

	  routeLengths = []


	  @routes.each do |route|
	  	duration = 0

		  route['segments'].each do |segment|
		  	if segment['isMajor'] == 1
		  		duration += segment['duration'].to_i
		  	end

		  	#Correcting fontawesome flight and ferry icons and adding flight airport codes
	  		if segment['kind'].to_s ==	"flight"
	  			segment['kindIcon'] = "plane"
	  			segment['source'] = segment['sCode'].to_s
	  			segment['target'] = segment['tCode'].to_s
	  		elsif segment['kind'].to_s == "ferry"
	  			segment['kindIcon'] = "ship"
	  			segment['source'] = segment['sName']
	  			segment['target'] = segment['tName']
	  		else
	  			segment['kindIcon'] = segment['kind'].to_s
	  			segment['source'] = segment['sName'].to_s
	  			segment['target'] = segment['tName'].to_s
	  		end

		  end
		  routeLengths << duration.to_i
		  
	
		  if duration >= routeLengths.max
		  	@routeLongest = duration
		  end

		  route['durationMajor'] = duration.to_i
		  route['durationText'] = minutes_to_hours(duration)


		  #Adding currency symbol to price e.g. $
		  if route['indicativePrice']['currency'].to_s == "USD"
		  	route['indicativePrice']['currencySym'] = "$" 
		  end

		end

	end

	def minutes_to_hours(minutes)
		hr = minutes / 60
		min = minutes % 60
		return "#{hr}h #{min}min"  

	end

end

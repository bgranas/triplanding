module TransportationHelper

	include HTTParty



	def r2r_call

	  response = HTTParty.get("http://free.rome2rio.com/api/1.2/json/Search?key=PZgcLuJc&oPos="+@originCoords+"&dPos="+@destinationCoords+"&flags=0x00000002")
	  @routes = response['routes']

	  airports = {}
	  response['airports'].each do |airport|
	  	airport_lat = airport['pos'].split(',')[0]
	  	airport_lng = airport['pos'].split(',')[1]
	  	code = airport['code']
	  	airports[code+'_lat'] = airport_lat
	  	airports[code+'_lng'] = airport_lng
	  end

	  routeLengths = []
	  allPaths = []
	  flightPathsLat = []
	  flightPathsLng = []
	  

	  @routes.each do |route|
	  	duration = 0
	  	routePath = []
	  	flightPathLat = []
	  	flightPathLng = []

		  route['segments'].each do |segment,i=0|

		  	if segment['isMajor'] == 1
		  		duration += segment['duration'].to_i
		  		if segment['kind'] == "flight"
		  			#first add the lat of the source, then the lat of the end
		  			flightPathLat << airports[segment['sCode']+'_lat']
		  			flightPathLat << airports[segment['tCode']+'_lat']
		  			#puts flightPathLat.to_yaml
		  			#first add the lng of the source, then the lat of the end
		  			flightPathLng << airports[segment['sCode']+'_lng']
		  			flightPathLng << airports[segment['tCode']+'_lng']
		  			#puts "*************flight path inside" + flightPath.to_s
		  		end
	  			
	  			routePath << segment['path'].to_s
	  			#puts "*************routePath" + routePath.to_s
		  		#puts "*************flight path outside" + flightPath.to_s
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

		  if flightPathLat.empty? == false
		  	flightPathsLat << flightPathLat
		  	flightPathsLng << flightPathLng
		  	#puts "*****flight paths lat" + flightPathsLat.to_yaml
		  end

		  allPaths << routePath
	
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

		gon.airportPathsLng = flightPathsLng
		gon.airportPathsLat = flightPathsLat
		gon.routePaths = allPaths
		puts "******route Airpot Paths Lat: " + gon.airportPathsLat.to_s

	end

	def minutes_to_hours(minutes)
		hr = minutes / 60
		min = minutes % 60
		return "#{hr}h #{min}min"  

	end

end

module TransportationHelper

	include HTTParty



	def r2r_call
	  @response = HTTParty.get("http://free.rome2rio.com/api/1.2/json/Search?key=PZgcLuJc&oPos="+@originCoords+"&dPos="+@destinationCoords+"")


	  @routes = []

	  @routeID = 0
	  @routeDistance = []
	  @routePrice = []
	  @routeDuration = []
	  @segmentName = []
	  @segmentTarget = []
	  @segmentDistance = []
	  @segmentDuration = []
	  @segmentPrice = []
	  
	  #@segmentOption = ""@routeSegment.to_s + " to " + @routeTarget.to_s","

	  @response['routes'].each do |route|
	  	@routes << route['name']
	  	@routePrice << route['indicativePrice']['price']
	  	@routeDistance << route['distance']
	  	@routeDistance << route['duration']
	  end

		@response['routes'][@routeID]['segments'].each do |segment|
			@segmentName << segment['kind']# +" to "+f['tName']
			@segmentTarget << segment['tName']
			@segmentDistance << segment['distance']
			@segmentPrice << segment['indicativePrice']['price']
			@segmentDuration << segment['duration']
			
		end

		puts '***** route price:' + @routePrice.to_s
		puts '***** route distance:' + @routeDistance.to_s
		puts '***** route duration:' + @routeDuration.to_s
		puts '***** segments:' + @segmentName.to_s
		puts '***** targets:'  + @segmentTarget.to_s
		puts '***** distance:' + @segmentDistance.to_s
		puts '***** segment duration:' + @segmentDuration.to_s
		puts '***** price:' + @segmentPrice.to_s 		

	end

	def show_routes

	end

end
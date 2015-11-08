module TransportationHelper

	include HTTParty



	def r2r_call
	  @response = HTTParty.get("http://free.rome2rio.com/api/1.2/json/Search?key=PZgcLuJc&oPos="+@originCoords+"&dPos="+@destinationCoords+"&0x00400000")


	  @routes = []

	  @routeID = 0
	  @routeSegments = []
	  @routeTarget = []
	  #@segmentOption = ""@routeSegment}" to "@routeTarget}""

	  @response['routes'].each do |route|
	  	@routes << route['name']
	  end

		@response['routes'][@routeID]['segments'].each do |segment|
			@routeSegments << segment['kind']# +" to "+f['tName']
			@routeTarget << segment['tName']
		end

		puts @routeSegments

	end

	def show_routes

	end

end
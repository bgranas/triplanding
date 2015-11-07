module TransportationHelper

	include HTTParty



	def r2r_call
	  @response = HTTParty.get("http://free.rome2rio.com/api/1.2/json/Search?key=PZgcLuJc&oPos="+@originCoords+"&dPos="+@destinationCoords+"")


	  @routes = []
	  @routeSegments = @response['routes'][0]['segments'][0]['kind']

	  @response['routes'].each do |i|
	  	@routes << i['name']
	  end

		#@response['routes'].each do |i|
	  #	i['segments'].each do |f|
		#		@routeSegments << f['kind'] #+" to "+i['tName']
		#	end
		#end

	end

	def show_routes

	end

end
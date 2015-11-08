module TransportationHelper

	include HTTParty



	def r2r_call
	  @response = HTTParty.get("http://free.rome2rio.com/api/1.2/json/Search?key=PZgcLuJc&oPos="+@originCoords+"&dPos="+@destinationCoords+"")
	  @routes = @response['routes']

	end

	def show_routes

	end

end

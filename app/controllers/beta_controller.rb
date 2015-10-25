class BetaController < ApplicationController
  include TripDisplayHelper


  def index
    @transparent_nav = true

    #calling Trip Display helper
    trip_display

  end

  def about
  end

  def contact
  end
end

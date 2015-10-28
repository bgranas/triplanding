class BetaController < ApplicationController
  include TripDisplayHelper


  def index
    @transparent_nav = true

    @page_title = "Home"

    #calling Trip Display helper
    trip_display_setup

  end

  def about
    @page_title = "About"
  end

  def contact
    @page_title = "Contact Us"
  end

  def blog
    @page_title = "Blog"
  end

  def help
    @page_title = 'Help'
  end

  def how_it_works
    @page_title = 'How it Works'
  end

  def policies
    @page_title = 'Site Policies'
  end

  def privacy
    @page_title = 'Privacy Policies'
  end

  def terms
    @page_title = 'Terms of Use'
  end
end

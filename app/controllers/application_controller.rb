class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_filter :store_location

  #helper :all

  def store_location
    # store last url as long as it isn't a /users path
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/
  end

  #after login, redirect to previous page, or the root URL if session is not defined
  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end


  #keep user on same page after signout
  def after_sign_out_path_for(user)
    request.referrer
  end
end

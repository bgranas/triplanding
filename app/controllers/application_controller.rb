class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_filter :store_location


  def store_location

    # store last url as long as it isn't a /users path
    if (request.path != "/d/users/sign_in" &&
      request.path != "/login" &&
      request.path != "/signup" &&
      request.path != "/d/users/sign_up" &&
      request.path != "/d/users/password/new" &&
      request.path != "/d/users/password/edit" &&
      request.path != "/d/users/confirmation" &&
      request.path != "/d/users/sign_out" &&
      request.path != "/logout" &&
      !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end

  end

  #after login, redirect to previous page, or the root URL if session is not defined
  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end


  #keep user on same page after signout
  def after_sign_out_path_for(resource)
    request.referrer
  end

protected

  def verify_is_admin
      if not current_user.try(:isAdmin?)
        #puts '***********previous session URL: ' + session[:previous_url].to_s
        if user_signed_in?
          redirect_to home_path
        else
          store_location
          redirect_to new_user_session_path
        end
      end
  end

end

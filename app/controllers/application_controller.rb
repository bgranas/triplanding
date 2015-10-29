class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_filter :store_location


  def store_location

    # store last url as long as it isn't a /users path
    if (request.path != "/users/sign_in" &&
      request.path != "/login" &&
      request.path != "/users/sign_up" &&
      request.path != "/users/password/new" &&
      request.path != "/users/password/edit" &&
      request.path != "/users/confirmation" &&
      request.path != "/users/sign_out" &&
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
        redirect_to new_user_session_path
      end
  end

end

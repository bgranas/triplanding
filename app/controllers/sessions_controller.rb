class SessionsController < Devise::SessionsController
  respond_to :html, :json

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?


    if request.format.html?
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      return render :json => {:success => true, :redirect => after_sign_in_path_for(resource)}
    end
  end
end

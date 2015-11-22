class SessionsController < Devise::SessionsController
  respond_to :html, :json

  layout "bare_bones_centerbox", :only => [:new]

  # TAKEN straight from devise
  # GET /resource/sign_in
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_with(resource, serialize_options(resource))
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    if block_given?
      yield resource
    end

    if request.format.html?
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      return render :json => {:success => true, location: after_sign_in_path_for(resource)}
    end
  end
end

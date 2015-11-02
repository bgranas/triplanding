class RegistrationsController < Devise::RegistrationsController
  respond_to :html, :json

  layout "bare_bones_centerbox", :only => [:new]

  before_filter only: [:new] do
    params.delete(:isAdmin)
  end

  # GET /resource/sign_up
  # Devise original code, with page_title added
  def new
    @page_title = 'Sign Up'
    build_resource({})
    set_minimum_password_length
    yield resource if block_given?
    respond_with self.resource
  end


  # POST /resource
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      #puts '************************sign-up successful'
      if resource.active_for_authentication?
        #puts '************************ resource.active_for_authentication'
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)

        if request.format.html?
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          return render :json => {:success => true, :redirect => after_sign_in_path_for(resource), :errors => resource.errors.full_messages}
        end

      else
        #puts '************************ resource NOT ACTIVE'
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      #puts '************************sign-up failed. format: ' + request.format
      clean_up_passwords resource
      set_minimum_password_length
      respond_to do |format|
        format.html {respond_with resource}
        format.js { return render :json => {:success => false, :errors => resource.errors.full_messages } }
      end
    end
  end



  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end

  def after_sign_up_path_for(user)
    session[:previous_url] || root_path
  end

end

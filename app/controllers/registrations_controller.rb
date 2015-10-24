class RegistrationsController < Devise::RegistrationsController

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

  def after_update_path_for(user)
    session[:previous_url] || root_path
  end

end

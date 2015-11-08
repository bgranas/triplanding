class AdminController < ApplicationController
  layout 'admin'

  before_action :verify_is_admin

  def index
    @page_title = 'All Users'

    @users = User.order("created_at ASC")

    render 'all_users'
  end

  def all_users
    @page_title = 'All Users'

    @users = User.order("created_at ASC")

    render 'all_users'
  end

  def edit_user
    @autocomplete_page = true
    @user = User.find(params[:id])

    @page_title = "Edit " + @user.name

  end

  def update_user
    #find an existing object using parameters
    @user = User.find(params[:id])
    #update the object
    if @user.update_attributes(user_params)
      #succeeds
      flash[:notice] = "Updated succesfully"
      redirect_to(:action => 'all_users')
    else
      #fails
      render('edit_user')
    end
    #if save succeeds, redirect to the index action
    #if save fails, redisplay the form so user can fix problems
  end

  def delete_user
    @user = User.find_by_id(params[:id])
  end

  def destroy_user
    @user = User.find_by_id(params[:id])
    @user.destroy
    redirect_to(:action => 'all_users')
  end

 private

  def user_params
    params.require(:user).permit(:name, :email, :blog_url, :profile_picture_path, :hometown, :country, :profile_url)
  end


end

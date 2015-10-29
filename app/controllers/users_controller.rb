class UsersController < ApplicationController

	layout 'application'

	include TripDisplayHelper

  before_action :authenticate_user!, only: [:edit, :update, :destroy, :delete]



  #List all users for admins to view/edit/delete


	def show

		#User info

		@user = User.find_by_profile_url(params[:profile_url])  #for searching by user URL
    raise ActiveRecord::RecordNotFound if  @user.nil? #user was not found




		@page_title = @user.name + "\'s Profile"

		#User scores placeholders for now
		@numTrips = 5  # number of trips user has created
		@upvoteScore = 20 # user reputation score
		@numCountriesVisited = 5 # total number of countries present in user's created trips

		#calling Trip Display helper
    trip_display_setup

    #To prevent username from displaying on trip list
    @show_username = false;

	end

  def edit
    @user = User.find(params[:id])
    validate_current_user_is_user
  end

  def update
    #find an existing object using parameters
    @user = User.find(params[:id])
    validate_current_user_is_user

    #update the object
    if @user.update_attributes(user_params)
      #succeeds
      flash[:notice] = "Updated succesfully"
      redirect_to(:action => 'show', :id => @user.id)
    else
      #fails
      render('edit')
    end
    #if save succeeds, redirect to the index action
    #if save fails, redisplay the form so user can fix problems
  end


  def delete
    @user = User.find_by_id(params[:id])
    validate_current_user_is_user
  end

  def destroy
    @user = User.find_by_id(params[:id])
    validate_current_user_is_user

    @user.destroy
    redirect_to(home_path)
  end

  private

  def user_params
  	params.require(:user).permit(:name, :email, :blog_url, :profile_picture_path, :hometown, :country, :profile_url)
  end

  def validate_current_user_is_user
    redirect_to home_path if not @user.id == current_user.id
  end


end

class UsersController < ApplicationController

	layout 'bare_bones_centerbox', :only => [:finish_signup]

	include TripDisplayHelper

  before_action :authenticate_user!, only: [:edit, :update, :destroy, :delete]


	def show
    @map_page = true

		#User info
		@user = User.find_by_profile_url(params[:profile_url])  #for searching by user URL
    raise ActiveRecord::RecordNotFound if  @user.nil? #user was not found

    if @user.external_picture_url?
      @profile_image_path = @user.external_picture_url
    else
      @profile_image_path = 'profile_pics/' + (@user.profile_picture_path).to_s
    end

		@page_title = @user.name + "\'s Profile"

		#User scores placeholders for now
		@numTrips = 5  # number of trips user has created
		@upvoteScore = 20 # user reputation score
		@numCountriesVisited = 5 # total number of countries present in user's created trips

		#calling Trip Display helper
    trip_display_setup

    #To prevent username from displaying on trip list
    #@show_username = false;

	end

  def edit
    @autocomplete_page = true
    @user = User.find_by_id(params[:id])
    validate_current_user_is_user
  end

  def update
    #find an existing object using parameters
    @user = User.find_by_id(params[:id])
    validate_current_user_is_user

    #update the object
    if @user.update_attributes(user_params)
      #succeeds
      flash[:notice] = "Updated succesfully"
      redirect_to(:action => 'show', :profile_url => @user.profile_url)
    else
      #fails
      render('edit')
    end
    #if save succeeds, redirect to the index action
    #if save fails, redisplay the form so user can fix problems
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    # authorize! :update, @user
    if request.patch? && params[:user] #&& params[:user][:email]
      @user = User.find_by_id(params[:id])
      if @user.update(user_params)
        #@user.skip_reconfirmation!
        sign_in(@user, :bypass => true)
        redirect_to(:action => 'show', :profile_url => @user.profile_url)
      else
        @show_errors = true
      end
    end
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
  	params.require(:user).permit(:name, :email, :blog_url, :profile_picture_path, :hometown, :country, :profile_url, :external_picture_url)
  end

  def validate_current_user_is_user
    redirect_to home_path if not @user.id == current_user.id
  end


end

class UsersController < ApplicationController

	layout 'application'

	include TripDisplayHelper




  #List all users for admins to view/edit/delete
	def index
	end

	def show

		#User info
		@user = User.find(params[:id])

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
  end

  def update
    #find an existing object using parameters
    @user = User.find(params[:id])
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
  end

  def destroy
    @user = User.find_by_id(params[:id])
    @user.destroy
    redirect_to(home_path)
  end

  private

  def user_params
  	params.require(:user).permit(:name, :email, :blog_url, :profile_picture_path, :hometown, :country, :profile_url)
  end


end

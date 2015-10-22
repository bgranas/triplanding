class LeadsController < ApplicationController

  layout false
  #respond_to :html, :js

  def index
    @leads = Lead.order("created_at ASC")
  end

  def show
  end

  def new

  end

  def create
    @lead = Lead.new(lead_params) #Create a new object without form parameters

  end

  def edit
  end

  def delete
  end


  private
    def lead_params
      params.require(:lead).permit(:email)
    end
end

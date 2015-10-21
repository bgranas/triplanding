class LeadsController < ApplicationController

  layout false

  def index
    @leads = Lead.order("created_at ASC")
  end

  def show
  end

  def new

  end

  def create
    @lead = Lead.new(lead_params) #Create a new object without form parameters

    if @lead.save
      #Successful save, notify user of success with flashtext

    else
      #Save failed, notify user with flash text

    end

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

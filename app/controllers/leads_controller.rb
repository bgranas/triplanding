class LeadsController < ApplicationController

  layout 'application'


  def index
    @leads = Lead.order("created_at ASC")
  end

  def show
  end

  def new

  end

  def create
    @lead = Lead.new(lead_params) #Create a new object without form parameters
    @saved = @lead.save

  end

  def edit
  end

  def delete
    @lead = Lead.find_by_id(params[:id])
  end

  def destroy
    @lead = Lead.find_by_id(params[:id])
    @lead.destroy
    redirect_to(:action => 'index')
  end


  private
    def lead_params
      params.require(:lead).permit(:email)
    end
end

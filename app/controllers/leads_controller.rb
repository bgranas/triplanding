class LeadsController < ApplicationController

  layout false

  def index
    @leads = Lead.order("created_at ASC")
  end

  def show
  end

  def new
  end

  def edit
  end

  def delete
  end
end

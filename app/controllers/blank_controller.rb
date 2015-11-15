class BlankController < ApplicationController

  #controller with the sole purpose of rendering partials in lightboxes
  layout 'blank'

  def snapshot_demo
    render 'snapshot_demo'
  end

end

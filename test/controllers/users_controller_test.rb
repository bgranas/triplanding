require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    #@request.env["devise.mapping"] = Devise.mappings[:user]
  end


  test "not authenticated should get show" do
    get :show
    assert_response :success
  end

end

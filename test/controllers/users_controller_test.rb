require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    #@request.env["devise.mapping"] = Devise.mappings[:user]
  end


  test "users/show without id should fail" do
    assert_raise ActiveRecord::RecordNotFound do
      get :show
    end
  end

  test "should not index if not logged in" do
    get :index
    assert_response :redirect, "no one is logged in, but are able to access users/index"
  end

end

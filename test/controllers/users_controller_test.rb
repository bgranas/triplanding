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

end

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


  


  #test users/index only loads for admin_user

  #test user id in correct format must be present for show

  #test show loads with profile URL

  #test show does not load with incorrect profile URL

  #test show will still load with nil profile picture

  #test show will still load with nil hometown

  #test show will still load with nil profile picture

  #test show will still load with nil blog_url

  test "should not index if not logged in" do
    get :index
    assert_response :redirect, "no one is logged in, but are able to access users/index"
  end


end

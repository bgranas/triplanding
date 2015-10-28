require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test "authenticated user should successfully get edit page" do
    sign_in users(:one)
    get :edit
    assert_response :success
  end

  test "not authenticated should get redirect when trying to edit user" do
    get :edit
    assert_response :redirect
  end

  test "not authenticated should get redirect when trying to update user" do
    get :update
    assert_response :redirect
  end

  test "not authenticated should get redirect when trying to destroy user" do
    get :destroy
    assert_response :redirect
  end

end

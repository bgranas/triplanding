require 'test_helper'

class LeadsControllerTest < ActionController::TestCase
  test "should not index if not logged in" do
    get :index
    assert_response :redirect
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit
    assert_response :success
  end

end

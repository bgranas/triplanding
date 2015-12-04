require 'test_helper'

class TripsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get delete" do
    get :delete
    assert_response :success
  end

  test "should get edit" do
    get :edit
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  #test saving blank title
  #test saving without logging in => redirect to login page
  #test saving being logged in associates trip to account
  #save trip without any destinations should succeed
  #testing saving trip is associated to user account if they register or login after creating
  #test deleting a trip and clicking no on confirmation
  #test deleting a trip and clicking yes on confirmation
  #favorite trip if logged in / not logged in
  #favrotie trip unsaved trip
  #try to delete trip user did not create
  #add valid trip dates, #add trip date start after trip date end


end

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

  ### ***********************************###
  ### ************ MAP TESTS ************###
  ### ***********************************###
  #reorder destinations should reorder pins
  #check valid polyline is created
  #remove destination from infowindow
  #add destination from infowindow
  #test trip metrics (including days)
  #saving should changed unsaved -> saved
  #adding dest should change saved -> unsaved
  #removing dest should change saved -> unsaved
  #reordering dest should change saved -> unsaved
  #adding destination date should change saved -> unsaved
  #adding trip dates should change saved -> unsaved
  #test saving blank title
  #test saving without logging in => redirect to login page
  #test saving being logged in associates trip to account
  #test saving with metrics
  #save trip without any destinations should succeed
  #testing saving trip is associated to user account if they register or login after creating
  #test deleting a trip and clicking no on confirmation
  #test deleting a trip and clicking yes on confirmation
  #test delting before logged in
  #favorite trip if logged in / not logged in
  #favrotie trip unsaved trip
  #try to delete trip user did not create
  #add valid trip dates, #add trip date start after trip date end

  ### ***********************************###
  ### ********* SNAPSHOT TESTS **********###
  ### ***********************************###

  #add destination
  #delete destination from snapshot
  #reorder destination (shoudl change itinerary too)
  #adding 100 destinations should trigger hover scroll to popup

  ### ***********************************###
  ### ********* ITINERARY TESTS *********###
  ### ***********************************###
  #add destination date
  #add destination date that is before the previous destination (shouldn't work)
  #editing destination date
  #add departure city (should return city)
  #click 'add' departure city, then cancel
  #click 'add' departure city, then cofirm
  #departure city edit, departure city delete
  #add return city
  #make sure departure and return city add transportation rows

end

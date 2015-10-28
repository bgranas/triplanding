require 'test_helper'

class BetaControllerTest < ActionController::TestCase

  test "the truth" do
    assert true
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end

  test "should get how it works" do
    get :how_it_works
    assert_response :success
  end

  test "should get blog" do
    get :blog
    assert_response :success
  end

  test "should get help" do
    get :help
    assert_response :success
  end

  test "should get site policies" do
    get :policies
    assert_response :success
  end

  test "should get privacy policy" do
    get :privacy
    assert_response :success
  end

  test "should get terms of service" do
    get :terms
    assert_response :success
  end



end

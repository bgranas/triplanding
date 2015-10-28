require 'test_helper'

class BetaControllerTest < ActionController::TestCase

  def setup
      setup_variables
  end

  test "the truth" do
    assert true
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_select "title",  "Home | #{@base_title}"
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select "title",  "About | #{@base_title}"
  end

  test "should get contact" do
    get :contact
    assert_response :success
    assert_select "title",  "Contact Us | #{@base_title}"
  end

  test "should get how it works" do
    get :how_it_works
    assert_response :success
    assert_select "title",  "How it Works | #{@base_title}"
  end

  test "should get blog" do
    get :blog
    assert_response :success
    assert_select "title",  "Blog | #{@base_title}"
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title",  "Help | #{@base_title}"
  end

  test "should get site policies" do
    get :policies
    assert_response :success
    assert_select "title",  "Site Policies | #{@base_title}"
  end

  test "should get privacy policy" do
    get :privacy
    assert_response :success
    assert_select "title",  "Privacy Policies | #{@base_title}"
  end

  test "should get terms of use" do
    get :terms
    assert_response :success
    assert_select "title",  "Terms of Use | #{@base_title}"
  end



end

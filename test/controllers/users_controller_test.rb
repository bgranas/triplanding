require 'test_helper'

class UsersControllerTest < ActionController::TestCase


  def setup
    #@request.env["devise.mapping"] = Devise.mappings[:user]
  end


  test "users/show without id should fail" do
    assert_raise ActiveRecord::RecordNotFound, "successfully accessed users/show" do
      get :show
    end
  end


  test "can't edit a user with a different id" do
    assert false, "need to write test"
  end


  test "user id in correct format must be present for show" do
    get :show, {:id => 1}
    assert_response :success, "cannot get /users/show/1, should be valid"

    assert_raise ActiveRecord::RecordNotFound, "successfully got /users/show/69, should be invalid" do
      get :show, {:id => 69}
    end
  end

  test "show loads with profile URL" do
    assert false, "need to write test"
  end

  test "show does not load with incorrect profile URL" do
    assert false, "need to write test"
  end

  test "show will still load with nil profile picture" do
    assert false, "need to write test"
  end

  test "show will still load with nil hometown" do
    assert false, "need to write test"
  end

  test "show will still load with nil blog_url" do
    assert false, "need to write test"
  end

  test "should not index if not logged in" do
    assert_raise AbstractController::ActionNotFound, "successfully got /users/index, should be invalid" do
      get :index
    end
  end

  test "should save edit with blog_url as empty string" do
    assert false, "need to write test"
  end

  test "should save edit with profile_url as empty string" do
    assert false, "need to write test"
  end

  test "should save edit with profile_picture_path as empty string" do
    assert false, "need to write test"
  end

  test "should save edit with hometown as empty string" do
    assert false, "need to write test"
  end

  test "should save edit with country as empty string" do
    assert false, "need to write test"
  end

end

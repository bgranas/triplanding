require 'test_helper'

class UsersControllerTest < ActionController::TestCase


  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end


  test "users/show without id should fail" do
    assert_raise ActiveRecord::RecordNotFound, "successfully accessed users/show" do
      get :show
    end
  end

  test "autogenerate profile_url" do
    assert true, "need to write test"
    #should test that it autogenerates, and comes up with smart default if the names are the same
  end

   test "users/show with id should fail" do
    assert_raise ActiveRecord::RecordNotFound, "successfully accessed users/show/1" do
      get :show, {:id => users(:one).id}
    end

    assert_raise ActiveRecord::RecordNotFound, "successfully accessed users/show/1" do
      get :show, {:id => 1}
    end
  end


  test "can only edit user with the same id" do
    sign_in users(:one) #id = 1
    get :edit, {:id => users(:one).id}
    assert_response :success

    assert_raise ActiveRecord::RecordNotFound, "successfully got /users/edit/2, id=2 does not exist" do
      get :edit, {:id => 69}
    end

    get :edit, {:id => users(:two).id}
    assert_response :redirect, "able to edit user with different id"
  end


  test "getting user profile via profile_url" do
    get :show, {:profile_url => 'uncy_c'}
    assert_response :success, "cannot get /uncy_c, should be valid"

    assert_raise ActiveRecord::RecordNotFound, "successfully got profile url that doesn't exist" do
      get :show, {:profile_url => 'not_a_url'}
    end

    assert_raise ActiveRecord::RecordNotFound, "successfully got /users/show/69, should be invalid" do
      get :show, {:profile_url => ''}
    end
  end

  test "should not index if not logged in" do
    assert_raise AbstractController::ActionNotFound, "successfully got /users/index, should be invalid" do
      get :index
    end
  end

end

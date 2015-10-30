require 'test_helper'

class UsersControllerTest < ActionController::TestCase


  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end


  test "users/show should fail always" do
    assert_raise ActiveRecord::RecordNotFound, "successfully accessed users/show" do
      get :show
    end
  end

  test "autogenerate profile_url" do
    test_user = User.new ({:name => "test", :email => "c@c.com", :password => '12345678', :password_confirmation => '12345678'})
    test_user.valid? #calls validation, should create profile_url = name
    assert_equal test_user.name, test_user.profile_url, "user profile_url does not match name"

    test_user.save!

    test_user2 = User.new ({:name => "test", :email => "c@c.com", :password => '12345678', :password_confirmation => '12345678'})
    test_user2.valid? #calls validation, should create profile_url = name_2
    assert_equal test_user2.profile_url, test_user2.name + '_2', "unsuccessfully generated profile_url when name was present"

    test_user3 = User.new ({:name => "  ", :email => "c@c.com", :password => '12345678', :password_confirmation => '12345678'})
    assert test_user3.invalid? , "user had no name, should not generate profile_url"
    assert test_user3.profile_url.nil?, "user had no name, profile_url should be nil" #name was blank, should have been nilled in last validation
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

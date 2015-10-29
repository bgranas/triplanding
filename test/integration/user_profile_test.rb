require 'test_helper'


class UserProfileTest < ActionDispatch::IntegrationTest

  def setup
    @test_user = User.new ({:name => 'test_user', :email => 'test@user.com', :password => '12345678', :password_confirmation => '12345678'})
    @test_user.save!

    @admin_user = User.new ({:name => 'admin_user', :email => 'admin@user.com', :password => '12345678', :password_confirmation => '12345678'})
    @admin_user.save!
    @admin_user.isAdmin = true
    @admin_user.save!
  end

  test "profile picture corrently defaults if not defined" do
    assert false, "need to write test"
  end

  test "blog url links to correct location" do
    assert false, "need to write test"
    #test external link
  end

  test "no url displayed if blog_url does not exist" do
    assert false, "need to write test"
  end

  test "edit user profile should preload values" do
    assert false, "need to write test"
  end

  test "should save edit with blog_url as empty string" do
    login_as(@test_user)
    visit '/users/edit/' + @test_user.id.to_s

    assert_current_path '/users/edit/' + @test_user.id.to_s
    #within('form') do
      #fill_in 'user_name'
    #end
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

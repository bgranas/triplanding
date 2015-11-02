require 'test_helper'


class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @test_user = User.new ({:name => 'test_user', :email => 'test@user.com', :password => '12345678', :password_confirmation => '12345678'})
    @test_user.save!

    @admin_user = User.new ({:name => 'admin_user', :email => 'admin@user.com', :password => '12345678', :password_confirmation => '12345678'})
    @admin_user.save!
    @admin_user.isAdmin = true
    @admin_user.save!
  end

  test "should get beta" do
    get '/beta'
    assert_response :success
    assert_template 'beta/index'
  end

  test "top navigation bar links" do
    get home_path
    assert_template 'beta/index'

    assert_select "a[href=?]", home_path
    assert_select "a[href=?]", how_it_works_path
    #to do add map, community, sign up, login paths
    #to do: add paths to links on dropdown if user is logged in
  end


  test "footer links" do
    get home_path
    assert_template 'beta/index'

    #testing internal links
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", blog_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", policies_path
    assert_select "a[href=?]", privacy_path
    assert_select "a[href=?]", terms_path

    #testing social links
    assert_select "a[href=?]", 'https://www.facebook.com/gotriphappy'
    assert_select "a[href=?]", 'https://instagram.com/gotriphappy'
    assert_select "a[href=?]", 'http://twitter.com/gotriphappy'
  end

  test "sucessfully redirected to admin section after admin login" do
    visit home_path
    visit leads_path
    assert_current_path new_user_session_path #should be redirected to login

    within('#new_user') do
      fill_in 'E-mail', with: 'admin@user.com'
      fill_in 'Password', with: '12345678'
      click_button 'Log in'
    end

    assert_current_path leads_path

  end

  test "admins can access leads/index and admins/all_users" do
    login_as(@admin_user)
    visit leads_path
    assert_current_path leads_path

    visit admin_users_path
    assert_current_path admin_users_path
  end

  test "without sign_in, admin page redirects to sign_in" do
    visit leads_path
    assert_current_path new_user_session_path
  end

  test "regular user cannot access admin pages" do
    login_as(@test_user)
    visit leads_path
    assert_no_current_path leads_path
  end

  test "testing signup form through popup" do
    visit home_path

    assert_no_selector ".lightbox-content" #popup box content has not loaded
    assert_no_text "uncle c" #username should not be displayed at top

    click_link('Sign Up')
    assert_selector '.lightbox-content'

    within("#signup-form") do
      fill_in 'Display Name', :with => 'unclec'
      fill_in 'E-mail', :with => 'test@test.com'
      fill_in 'Password', :with => '11111111'
      fill_in 'Confirm Password', :with => '11111111'
      click_button('Sign up')
    end

    visit home_path #if you don't do this, current_path = ajax request
    assert_current_path home_path

    within("#header") do
      assert_text "unclec" #username should be displayed at top
    end
  end

  test "showing errors on lightbox signup" do
    visit home_path

    assert_no_selector ".lightbox-content" #popup box content has not loaded
    click_link('Sign Up')
    assert_selector '.lightbox-content'


    within("#signup-form") do
      fill_in 'Display Name', :with => users(:one).name
      fill_in 'E-mail', :with => 'test@test.com'
      fill_in 'Password', :with => '11111'
      fill_in 'Confirm Password', :with => '11112'
      click_button('Sign up')
    end

    print page.html
    assert_text "Password is too short (minimum is 8 characters)"
    assert_text "Password confirmation doesn't match Password"

    #successfully creating account
    visit home_path
    click_link('Sign Up')
    within("#signup-form") do
      fill_in 'Display Name', :with => users(:one).name
      fill_in 'E-mail', :with => 'test@test.com'
      fill_in 'Password', :with => '11111111'
      fill_in 'Confirm Password', :with => '11111111'
      click_button('Sign up')
    end

    visit home_path
    within("#header") do
      assert_text users(:one).name #username should be displayed at top
    end


    #logging out of created account
    click_link('Logout', visible: false)

    #still on homepage after logout
    assert_current_path home_path


    click_link('Sign Up')
    assert_selector '.lightbox-content'
    #checking if you get e-mail is already taken error
    within("#signup-form") do
      fill_in 'Display Name', :with => 'uncle c'
      fill_in 'E-mail', :with => 'test@test.com'
      fill_in 'Password', :with => '11111111'
      fill_in 'Confirm Password', :with => '11111111'
      click_button('Sign up')
    end

     assert_text "Email has already been taken"

  end

end

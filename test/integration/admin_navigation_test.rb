require 'test_helper'


class AdminNavigationTest < ActionDispatch::IntegrationTest

  def setup
    @test_user = User.new ({:name => 'test_user', :email => 'test@user.com', :password => '12345678', :password_confirmation => '12345678'})
    @test_user.save!

    @admin_user = User.new ({:name => 'admin_user', :email => 'admin@user.com', :password => '12345678', :password_confirmation => '12345678'})
    @admin_user.save!
    @admin_user.isAdmin = true
    @admin_user.save!
  end

  #test show/edit/delete links on admin navigation
  #test "users" and "leads" links on admin navigation
end

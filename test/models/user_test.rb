require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "creating valid user" do
    user = User.new
    assert user.invalid?

    user.name = 'uncle c'
    user.email = 'est@test.com'
    user.password = '12345678'
    user.password_confirmation = '12345678'

    assert user.valid?
  end

  test "user email must not be empty" do
    user = User.new
    assert user.invalid?
    assert user.errors[:email].any?
  end

  test "user must confirm password" do
    user = User.new
    assert user.invalid?
    assert user.errors[:email].any?
  end

  test "e-mail must be unique" do
    user = User.new ({:name => 'test', :email => 'test@test.com', :password => '12345678', :password_confirmation => '12345678'})
    assert user.valid?
    user.save!

    user2 = User.new ({:name => 'test', :email => 'test@test.com', :password => '12345678', :password_confirmation => '12345678'})
    assert user2.invalid?
  end

  test "display name is not unique" do
    user = User.new ({:name => 'test', :email => 'test@test.com', :password => '12345678', :password_confirmation => '12345678'})
    assert user.valid?

    user.save!

    user2 = User.new ({:name => 'test', :email => 'test2@test.com', :password => '12345678', :password_confirmation => '12345678'})

    assert user2.valid?
  end

  test "submitting invalid URL for blog" do
     user = User.new ({:name => 'test', :email => 'test@test.com',
                        :password => '12345678', :password_confirmation => '12345678',
                        :blog_url => "asdfd"})
     assert user.invalid?
  end

end

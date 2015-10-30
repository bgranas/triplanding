    require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "creating valid user" do
    user = User.new
    assert user.invalid?

    user.name = 'uncle c'
    user.email = 'est@test.com'
    user.password = '12345678'
    user.password_confirmation = '12345678'

    assert user.valid?, "cannot save user with name uncle c"

    #adding all fields
    user.hometown = "Los Gatos"
    user.country_iso_3 = "USA"
    user.country = "United States"
    user.blog_url = "www.google.com"
    user.profile_url = "test-acas"
    user.profile_picture_path = "asdfasdf.jpg"
    user.isAdmin = false

    assert user.valid?, "cannot save user with all attributes"

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
    assert user.valid?, "cannot create valid user"

    user.save!

    user2 = User.new ({:name => 'test', :email => 'test2@test.com', :password => '12345678', :password_confirmation => '12345678'})

    assert user2.valid?, "was not able to create user with same display name"
  end

  test "valid blog url" do
     user = User.new ({:name => 'test', :email => 'test@test.com',
                        :password => '12345678', :password_confirmation => '12345678',
                        :blog_url => "www.test.com"})
     assert user.valid?, "cannot save valid blog url"
  end

  test "valid profile_url" do

     user = User.new ({:name => 'test', :email => 'test@test.com',
                        :password => '12345678', :password_confirmation => '12345678',
                        :profile_url => "calvin-hawkes"})
     assert user.valid?, "cannot submit valid profile url"

     user.profile_url = "99823"
     assert user.valid? , "can submit profile url with only numbers"

     user.profile_url = "69mebaby"
     assert user.valid? , "can submit profile url with numbers first"

     user.profile_url = "babylike69"
     assert user.valid?, "numbers should be allowed at the end of a profile_url"

     user.profile_url = "baby69me"
     assert user.valid?, "numbers should be allowed in the middle of a profile_url"
  end


  test "submitting invalid URL for blog" do
     user = User.new ({:name => 'test', :email => 'test@test.com',
                        :password => '12345678', :password_confirmation => '12345678',
                        :blog_url => "asdfd"})
     assert user.invalid?
  end

  test "calling my display name bad words" do
    user = User.new ({:name => 'nigger', :email => 'test@test.com',
                        :password => '12345678', :password_confirmation => '12345678'})
    assert user.invalid?

    user.name = "cunt"
    assert user.invalid?

    user.name = "shit"
    assert user.invalid?

    user.name = 'gumby'

    assert user.valid?
  end

  test "trying invalid usernames" do
    user = User.new ({:name => ' ', :email => 'test@test.com',
                        :password => '12345678', :password_confirmation => '12345678'})
    assert user.invalid?

    user.name = "_test"
    assert user.invalid?

    user.name = "test_"
    assert user.invalid?

    user.name = "test "
    assert user.invalid?

    user.name = "test-"
    assert user.invalid?

    user.name = "test-"
    assert user.invalid?

    user.name = "-test"
    assert user.invalid?

    user.name = " test"
    assert user.invalid?

    user.name = "test__t"
    assert user.invalid?

    user.name = "test--asdf"
    assert user.invalid?

    user.name = "test  asdf"
    assert user.invalid?

    user.name = "t"
    assert user.invalid?

    user.name = "222222222222222222222222222"
    assert user.invalid?

    user.name = "te:aass"
    assert user.invalid?

    user.name ="2asdf"
    assert user.valid?

    user.name ="2a$df"
    assert user.invalid?

    user.name ="uncle creepy"
    assert user.valid?

    user.name ="ben granas"
    assert user.valid?

    user.name ="chawxx"
    assert user.valid?

    user.name = 'gumby'

    assert user.valid?
  end

  test "valid / invalid hometown names" do
    user = User.new ({:name => 'aaaa', :email => 'test@test.com',
                        :password => '12345678', :password_confirmation => '12345678'})
    assert user.valid?

    user.hometown = 'ttests'
    assert user.valid?

    user.hometown = 'calvin\'s town'
    assert user.valid?

    user.hometown = 'dr. calvin'
    assert user.valid?

    user.hometown = 'calvin-town'
    assert user.valid?

    user.hometown = 'čćę'
    assert user.valid?

    user.hometown = 'ÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁ'
    assert user.valid?

    user.hometown = 'ad#'
    assert user.invalid?

    user.hometown = 'calvin@calvin.town'
    assert user.invalid?

    user.hometown = '' #blank string will be converted to nil when saved
    assert user.valid?, "blank hometown unable to save (should have converted to nil before validation)"

    user.hometown = '   ' #string with spaces will be converted to nil when saved
    assert user.valid?, "blank hometown unable to save (should have converted to nil before validation)"


    user.hometown = '111'
    assert user.invalid?

    long_town = ""
    105.times {long_town = long_town + "x"}
    user.hometown = long_town
    assert user.invalid?

    long_town = ""
    90.times {long_town = long_town + "x"}
    user.hometown = long_town
    assert user.valid?
  end

  test "profile url must be unique and not contain symbols" do
    user = User.new ({:name => 'aaaa', :email => 'test@test.com',
                        :password => '12345678', :password_confirmation => '12345678'})
    assert user.valid?

    user.profile_url = "test-test"
    assert user.valid?, "Profile URL with - unable to save"

    user.profile_url = "test_Test"
    assert user.valid?, "Profile URL with _ unable to save"

    user.profile_url = "test*Test"
    assert user.invalid?, "Profile URL with * (invalid symbol) able to save"

    user.profile_url = "test"
    assert user.valid?, "Plain string Profile URL unavailable to save"

    user.save!

    user2 = User.new ({:name => 'aaaa', :email => 'test2@test.com',
                        :password => '12345678', :password_confirmation => '12345678'})
    assert user2.valid?

    user2.profile_url = "test"
    assert user2.invalid?, "Two users with the same URL saved"

  end


end

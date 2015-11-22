require 'helpers/constants.rb'

class User < ActiveRecord::Base
  has_many :user_trips
  has_many :trips, :through => :user_trips

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  NULL_ATTRS = %w( hometown country_iso_3 country blog_url profile_url profile_picture_path name email )
  before_validation :nil_if_blank
  before_validation :generate_profile_url #WARNING: This must be run after nil_if_blank is run
  before_save :generate_profile_url

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/
  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  validates :blog_url, :allow_nil => true, :format => URL_VALLIDATION
  validates :name, :presence => true, :length => { :minimum => 2, :maximum => 20},
            :exclusion => { in: FORBIDDEN_USERNAMES }, :format => NAME_REGEX
  validates :hometown, :allow_nil => true, :length => { :minimum => 1, :maximum => 100},
                       :format => HOMETOWN_REGEX
  validates :country,  :allow_nil => true, :length => { :minimum => 2, :maximum => 50}, :format => HOMETOWN_REGEX
  validates :profile_url, :allow_nil => false, :uniqueness => true, :format => PROFILE_URL

  #method taken from tutorial on facebook authorization here:
  #http://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/#generate-migrations-and-models
  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email || auth.extra.raw_info.email_verified)
      email = auth.info.email if email_is_verified

      #puts '********************auth: ' + auth.to_yaml
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?

        user = User.create_user_from_provider(auth)
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end


  #for each provider, setup the correct variables
  def self.create_user_from_provider(auth)
    debug = false
    user = User.new

    case auth.provider
    when 'instagram'
=begin
      provider: instagram
      uid: '2215814867'
      info: !ruby/hash:OmniAuth::AuthHash::InfoHash
        nickname: gotriphappy
        name: TripHappy
        image: https://igcdn-photos-h-a.akamaihd.net/hphotos-ak-xat1/t51.2885-19/s150x150/12135481_1094337037257663_2066194489_a.jpg
        bio: A better way to explore the world. Coming soon.
        website: http://www.triphappy.me/
      credentials: !ruby/hash:OmniAuth::AuthHash
        token: 2215814867.ef8035d.11d0fba3b92c4739bd9c8e02a9aae5b8
        expires: false
=end
      user.name = auth.info.name
      user.external_picture_url = auth.info.image
      user.password = Devise.friendly_token[0,20]
      user.email = "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com"

    when 'google_oauth2'
=begin
      provider: google_oauth2
      uid: '113787838177262795032'
      info: !ruby/hash:OmniAuth::AuthHash::InfoHash
        name: Calvin Hawkes
        email: calvinhawkes@gmail.com
        first_name: Calvin
        last_name: Hawkes
        image: https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg
      credentials: !ruby/hash:OmniAuth::AuthHash
        token: ya29.IQJR1OeZoQcROKvp4wMvzi2DheCew_N2FiAFAlGTsbmBkRz0JsXOEacMa7CmXn70FZAiQQ
        expires_at: 1446530609
        expires: true
      extra: !ruby/hash:OmniAuth::AuthHash
        id_token: eyJhbGciOiJSUzI1NiIsImtpZCI6ImE0ODhkOWRkNGJjOTg1MmQ1YzkwZGFhMTY4N2FkMTNiYWRlNGJiZmMifQ.eyJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwiYXRfaGFzaCI6InVhNk1HTkt4cmM3WUNrSjBPWHpmZWciLCJhdWQiOiI3MDI1NjEzMTcwMTQtZDg0bGIycjI2NXFiMDc1YmxtaWtmdTNyN2YxNzVlcWcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTM3ODc4MzgxNzcyNjI3OTUwMzIiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXpwIjoiNzAyNTYxMzE3MDE0LWQ4NGxiMnIyNjVxYjA3NWJsbWlrZnUzcjdmMTc1ZXFnLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiZW1haWwiOiJjYWx2aW5oYXdrZXNAZ21haWwuY29tIiwiaWF0IjoxNDQ2NTI3MDA5LCJleHAiOjE0NDY1MzA2MDl9.MvkD1Dd3V146ys7xDTjYYngmvqjVpo1r7Gjp0jFMIQiYFHc76TPQi2g2PFZqb-Esd5NKS5Q1mu9yiXH1FiGTH3KpjEMldH9rEX02pZy3ds_0Kp66dbmHWRzNKwyaLZRkjsKIOxpHDnWoJXHAq8muXIb1I9uXdUan2HGVY_MGtGY19g0N0l8hCbIcAEoAeD-fBcYO05XQB3Tmw3CO-uIUKW4CFDkIsTcx6dzlpt7sONJH5A4Zty6TysE-cjm1e8Op-ImK3E8wevHqhVTQQhHv_5itgrmLzZ_2geY1Zxfip_Mob6SngknQMTeDlxwEuiHRc7X3AcVEOzpoiLNytbQrkQ
        id_info: !ruby/hash:OmniAuth::AuthHash
          iss: accounts.google.com
          at_hash: ua6MGNKxrc7YCkJ0OXzfeg
          aud: 702561317014-d84lb2r265qb075blmikfu3r7f175eqg.apps.googleusercontent.com
          sub: '113787838177262795032'
          email_verified: true
          azp: 702561317014-d84lb2r265qb075blmikfu3r7f175eqg.apps.googleusercontent.com
          email: calvinhawkes@gmail.com
          iat: 1446527009
          exp: 1446530609
        raw_info: !ruby/hash:OmniAuth::AuthHash
          kind: plus#personOpenIdConnect
          sub: '113787838177262795032'
          name: Calvin Hawkes
          given_name: Calvin
          family_name: Hawkes
          picture: https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg?sz=50
          email: calvinhawkes@gmail.com
          email_verified: 'true'
          locale: en
=end
      email_is_verified = auth.info.email && auth.extra.raw_info.email_verified
      user.email = email_is_verified ? auth.info.email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com"
      user.name = auth.info.first_name
      user.password = Devise.friendly_token[0,20]
      user.external_picture_url = auth.info.image
    when 'facebook'
=begin
      provider: facebook
      uid: '10154414490583902'
      info: !ruby/hash:OmniAuth::AuthHash::InfoHash
        email: teamgonuts@gmail.com
        first_name: Calvin
        image: http://graph.facebook.com/10154414490583902/picture?width=200&height=200
        location: New York, New York
        verified: true
      credentials: !ruby/hash:OmniAuth::AuthHash
        token: CAACoZBe6BEuQBAISX0bhfpdy42ziB51P3zsU5XDxILOfpBokfWfEJP5rjnxCR4gaCEubajZAYf5ZCWtRf6YJWYHts7AZALXu2WRdn6m54ZAhC3ZCO5eDLpVpZAo7hMMFOORjQZAvPaAqZBw6nESzUlD6JZAxx4rRj0kQxSizYNLelXr2IZBzIgsJ6ZC85XWElIl4aUsZD
        expires_at: 1451705241
        expires: true
      extra: !ruby/hash:OmniAuth::AuthHash
        raw_info: !ruby/hash:OmniAuth::AuthHash
          first_name: Calvin
          email: teamgonuts@gmail.com
          picture: !ruby/hash:OmniAuth::AuthHash
            data: !ruby/hash:OmniAuth::AuthHash
              is_silhouette: false
              url: https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xtl1/v/t1.0-1/c54.0.512.512/s50x50/12144651_10154372827998902_2481560392751140253_n.jpg?oh=136688daa2515828386cec3485fb6f48&oe=56F9E55C&__gda__=1456008957_b12368953ad7853cd6bebe877a0ff828
          verified: true
          location: !ruby/hash:OmniAuth::AuthHash
            id: '108424279189115'
            name: New York, New York
          id: '10154414490583902'
=end

      email_is_verified = auth.info.email && auth.info.verified
      user.email = email_is_verified ? auth.info.email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com"
      user.name = auth.info.first_name
      user.external_picture_url = auth.info.image
      user.hometown = (auth.info.location).split(',')[0] #New York, New York -> New York
      user.password = Devise.friendly_token[0,20]
    else
      puts '*******something went wrong in user.set_variables_for_provider' if debug
      return nil
    end
    user.generate_profile_url #generate a profile_url from the name

    puts 'user.valid?: ' + user.valid?.to_s if debug
    puts user.to_yaml if debug
    return user
  end

  #pre: nil_if_blank must be run otherwise a name with empty spaces will cause SystemStackError: stack level too deep if user
  #generating unique profile url if one was not provided
  def generate_profile_url
    #need to replace spaces with strings
    debug = false

    if !self.name.nil? and self.profile_url.blank?
      temp_name = self.name.downcase.gsub(' ', '-').gsub('_', '-') #replacing spaces, underscores with dashes
      self.profile_url = temp_name #replacing spaces with dashes
      puts '************** profile_url: ' + self.profile_url if debug
      puts '************** self.errors[profile_url]: ' + self.errors[:profile_url].to_s if debug
      puts '************** User.find_by_profile_url(self.profile_url).nil?: ' +
                            (User.find_by_profile_url(self.profile_url).nil?).to_s if debug

      #there can be other reasons that the user is invalid, so we just want to keep checking
      #until there are no errors in the profile_url
      i = 2
      while not User.find_by_profile_url(self.profile_url).nil? do
        puts '************** self.errors[profile_url]: ' + self.errors[:profile_url].to_s if debug
        self.profile_url = temp_name + "_" + i.to_s
        puts '************** new profile_url ' + self.profile_url if debug
        #self.valid? #checking if valid, will generate new self.errors
        i = i + 1
      end

    end
  end

protected

  #removes blank values and instead makes nil
  def nil_if_blank
    #puts "******** nil_if_blank called"
    NULL_ATTRS.each { |attr| self[attr] = nil if self[attr].blank? }
  end



end


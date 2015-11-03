require 'helpers/constants.rb'

class User < ActiveRecord::Base
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

      name = auth.info.first_name ?  auth.info.first_name : auth.info.given_name
      puts '********************auth: ' + auth.to_yaml
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?

        user = User.new(
          name: name,
          external_picture_url: auth.info.image,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )

        user.generate_profile_url #generates profile URL based off name
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
        self.valid? #checking if valid, will generate new self.errors
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


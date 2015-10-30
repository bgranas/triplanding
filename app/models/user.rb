require 'helpers/constants.rb'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  NULL_ATTRS = %w( hometown country_iso_3 country blog_url profile_url profile_picture_path name email )
  before_validation :nil_if_blank
  before_validation :generate_profile_url #WARNING: This must be run after nil_if_blank is run


  validates :blog_url, :allow_nil => true, :format => URL_VALLIDATION
  validates :name, :presence => true, :length => { :minimum => 2, :maximum => 20},
            :exclusion => { in: FORBIDDEN_USERNAMES }, :format => NAME_REGEX
  validates :hometown, :allow_nil => true, :length => { :minimum => 1, :maximum => 100},
                       :format => HOMETOWN_REGEX
  validates :country,  :allow_nil => true, :length => { :minimum => 2, :maximum => 50}, :format => HOMETOWN_REGEX
  validates :profile_url, :allow_nil => false, :uniqueness => true, :format => PROFILE_URL


  protected

  #removes blank values and instead makes nil
  def nil_if_blank
    #puts "******** nil_if_blank called"
    NULL_ATTRS.each { |attr| self[attr] = nil if self[attr].blank? }
  end

  #pre: nil_if_blank must be run otherwise a name with empty spaces will cause SystemStackError: stack level too deep if user
  #generating unique profile url if one was not provided
  def generate_profile_url
    #need to replace spaces with strings
    debug = false

    if !self.name.nil? and self.profile_url.blank?
      self.profile_url = self.name #THIS LINE FAILS IF self.name is true
      self.valid? #testing to see if self is valid after profile url

      puts '************** user is not valid, but does the error have to do with profile_url?' if debug
      puts '************** self.errors[profile_url]: ' + self.errors[:profile_url].to_s if debug
      puts '************** User.find_by_profile_url(self.profile_url).nil?: ' +
                            (User.find_by_profile_url(self.profile_url).nil?).to_s if debug

      #there can be other reasons that the user is invalid, so we just want to keep checking
      #until there are no errors in the profile_url
      i = 2
      while not User.find_by_profile_url(self.profile_url).nil? do
        puts '************** self.errors[profile_url]: ' + self.errors[:profile_url].to_s if debug
        self.profile_url = self.name + "_" + i.to_s
        puts '************** new profile_url ' + self.profile_url if debug
        self.valid? #checking if valid, will generate new self.errors
        i = i + 1
      end

    end
  end



end


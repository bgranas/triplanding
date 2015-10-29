require 'helpers/constants.rb'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  NULL_ATTRS = %w( hometown country_iso_3 country blog_url profile_url profile_picture_path )

  before_validation :nil_if_blank
  before_validation :generate_profile_url



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

  #generating unique profile url if one was not provided
  def generate_profile_url
    debug = false
    if self.profile_url.blank?
      self.profile_url = self.name
      self.valid? #testing to see if self is valid after profile url

      puts '************** profile_url is taken' if debug
      puts '************** self.errors[profile_url]: ' + self.errors[:profile_url].to_s if debug

      #there can be other reasons that the user is invalid, so we just want to keep checking
      #until there are no errors in the profile_url
      i = 1
      while not self.errors[:profile_url].blank? do
        puts '************** self.errors[profile_url]: ' + self.errors[:profile_url].to_s if debug
        self.profile_url = self.name + "_" + i.to_s
        puts '************** new profile_url ' + self.profile_url if debug
        self.valid? #checking if valid, will generate new self.errors
        i = i + 1
      end

    end
  end



end


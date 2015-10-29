require 'helpers/constants.rb'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  NULL_ATTRS = %w( hometown country_iso_3 country blog_url profile_url profile_picture_path )

  before_validation :nil_if_blank



  validates :blog_url, :allow_nil => true, :format => URL_VALLIDATION
  validates :name, :presence => true, :length => { :minimum => 2, :maximum => 20},
            :exclusion => { in: FORBIDDEN_USERNAMES }, :format => NAME_REGEX
  validates :hometown, :allow_nil => true, :length => { :minimum => 1, :maximum => 100},
                       :format => HOMETOWN_REGEX
  validates :country,  :allow_nil => true, :length => { :minimum => 2, :maximum => 50}, :format => HOMETOWN_REGEX
  validates :profile_url, :allow_nil => true, :uniqueness => true, :format => PROFILE_URL


  protected

  #removes blank values and instead makes nil
  def nil_if_blank
    #puts "******** nil_if_blank called"
    NULL_ATTRS.each { |attr| self[attr] = nil if self[attr].blank? }
  end



end


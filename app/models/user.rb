require 'helpers/constants.rb'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  #Below is a list of curse words taken from GOOGLE'S banned words list!



  #Below is a list of curse words taken from GOOGLE'S banned words list!


  validates :blog_url, :allow_nil => true, :format => URL_VALLIDATION
  validates :name, :presence => true, :length => { :minimum => 2, :maximum => 20},
            :exclusion => { in: FORBIDDEN_USERNAMES }, :format => NAME_REGEX
  validates :hometown, :allow_nil => true, :length => { :minimum => 1, :maximum => 100},
                       :format => HOMETOWN_REGEX
  validates :country,  :allow_nil => true, :length => { :minimum => 2, :maximum => 50}
  validates :profile_url, :allow_nil => true, :uniqueness => true, :format => PROFILE_URL





end


class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  NAME_REGEX = /^(?=.{2,20}$)[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$/
  HOMETOWN_REGEX = /^[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]+$/u


  validates :name, :presence => true, :length => { :minimum => 2, :maximum => 20}, :format => NAME_REGEX, :confirmation => true
  validates :hometown, :presence => true, :allow_nil => true, :length => { :minimum => 1, :maximum => 100}, :format => HOMETOWN_REGEX, :confirmation => true
  validates :country, :presence => true, :allow_nil => true, :length => { :minimum => 2, :maximum => 50}, :format => HOMETOWN_REGEX, :confirmation => true


=begin
  Items for User:
  -Name (letters number and spaces, max 20 characters)
  -Email (max 50)
  -Password (max 75)
  -Hometown (unicode characters, max 100)
  -Country (max 5o)
  -Blog (url validator, max 100, post-url crawler)
  -Profile Picture path (valid path, max 100)
  -profile url (letters & characters, max-50, url safe on create)
=end
end

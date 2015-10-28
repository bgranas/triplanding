class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable




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

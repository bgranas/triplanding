class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


=begin
  Items for User:
  -Name
  -Email
  -Password
  -Hometown
  -Country
  -Blog
  -Profile Picture
  -profile url
=end
end

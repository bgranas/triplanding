class Lead < ActiveRecord::Base
  validates :email, email: true

end

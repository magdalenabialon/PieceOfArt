class User < ActiveRecord::Base

  validates :name, presence:true, allow_blank: false
  
  has_secure_password
  has_many :paintings
  has_many :comments

end

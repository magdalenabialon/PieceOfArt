class User < ActiveRecord::Base

  validates :name, presence:true, allow_blank: false

  has_secure_password

  # has_many :paintings
  has_many :comments
  has_many :likes
  has_many :paintings, through: :likes

end

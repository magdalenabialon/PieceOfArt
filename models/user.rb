class User < ActiveRecord::Base

  validates :name, presence:true, allow_blank: false

  has_secure_password

  has_many :paintings
  has_many :likes
  has_many :comments
  has_many :liked_paintings, through: :likes, source: :painting

end

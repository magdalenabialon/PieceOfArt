class Painting < ActiveRecord::Base

  validates :title, presence:true, allow_blank: false

  belongs_to :user
  has_many :likes
  has_many :comments
  has_many :users, through: :likes

  # geocoded_by :city  #use column name
  # # after_validation :geocode

end

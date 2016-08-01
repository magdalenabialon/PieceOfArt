class Painting < ActiveRecord::Base

  validates :title, presence:true, allow_blank: false

  belongs_to :user
  has_many :comments

end

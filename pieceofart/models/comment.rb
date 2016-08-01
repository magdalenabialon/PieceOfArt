class Comment < ActiveRecord::Base

  validates :comment, presence:true, allow_blank: false

  belongs_to :user
  belongs_to :painting

end

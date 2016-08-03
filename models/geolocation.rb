class GeoLocation < ActiveRecord::Base


  geocoded_by :full_street_address   # can also be an IP address
  after_validation :geocode


  geocoded_by :address, :latitude  => :lat, :longitude => :lon # ActiveRecord



  rails generate migration AddLatitudeAndLongitudeToModel latitude:float longitude:float
  rake db:migrate


  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }



  def address
  [street, city, state, country].compact.join(', ')
  end


  # validates :comment, presence:true, allow_blank: false
  #
  # belongs_to :user
  # belongs_to :painting

end

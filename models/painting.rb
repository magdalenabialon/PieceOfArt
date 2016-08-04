require 'geocoder'

class Painting < ActiveRecord::Base

  validates :title, presence:true, allow_blank: false

  belongs_to :user
  has_many :likes
  has_many :comments
  has_many :users, through: :likes

  before_save :do_geocode

  # attr_accessible :city, :latitude, :longitude

  # reverse_geocoded_by :latitude, :longitude
  # geocoded_by :city
  # after_validation :geocode

  def do_geocode
    coords = Geocoder.coordinates(self.city)
    self.latitude = coords[0]
    self.longitude = coords[1]
  end

end

require 'pry'
require 'geocoder'
require 'active_record'

# ActiveRecord::Base.logger = Logger.new(STDERR)
# require 'geocoder/lookups/base'

require_relative 'db_config'



require_relative 'models/comment'
require_relative 'models/painting'
require_relative 'models/user'
require_relative 'models/like'






binding.pry

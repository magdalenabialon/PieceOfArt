require 'active_record'


options = {
  adapter: 'postgresql',
  database: 'artdatabase'
}

ActiveRecord::Base.establish_connection( ENV['DATABASE_URL'] || options)

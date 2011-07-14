# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# Clean database
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

# Create a default user
AdminUser.create!(:email => 'admin@example.com', :password => 'password', :password_confirmation => 'password')

# Create test faculties
Faculty.create!(:name => 'Kaisaniemi post-hautomo', :code => 'KPH')

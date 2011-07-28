# coding: utf-8

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
AdminUser.create!(:email => 'admin@example.com', :password => 'password', :password_confirmation => 'password', :role => 'admin')

# Create test faculties
Faculty.create!(:name => 'Kaisaniemi post-hautomo', :code => 'KPH')

# Test users
AdminUser.create!(:email => 'mark@example.com', :password => 'password', :password_confirmation => 'password', :role => 'secretary')
AdminUser.create!(:email => 'twain@example.com', :password => 'password', :password_confirmation => 'password', :role => 'advocate')


# Voting areas
VotingArea.create! :code => 'I', :name => 'Unicafe Ylioppilasaukio'
VotingArea.create! :code => 'II', :name => 'Yliopiston päärakennus'
VotingArea.create! :code => 'III', :name => 'Yliopiston päärakennus'
VotingArea.create! :code => 'IV', :name => 'Porthania'
VotingArea.create! :code => 'V', :name => 'Porthania'
VotingArea.create! :code => 'VI', :name => 'Oppimiskeskus Aleksandria'
VotingArea.create! :code => 'VII', :name => 'Topelia'
VotingArea.create! :code => 'VIII', :name => 'Metsätalo'
VotingArea.create! :code => 'IX', :name => 'Valtiotieteellisen tdk:n'
VotingArea.create! :code => 'X', :name => 'Oppimiskeskus Minerva'
VotingArea.create! :code => 'XI', :name => 'Terveystieteiden keskus'
VotingArea.create! :code => 'XII', :name => 'Hammaslääketieteen'
VotingArea.create! :code => 'XIII', :name => 'Physicum'
VotingArea.create! :code => 'XIV', :name => 'Chemicum'
VotingArea.create! :code => 'XV', :name => 'Exactum'
VotingArea.create! :code => 'XVI', :name => 'Viikin Infokeskus'
VotingArea.create! :code => 'XVII', :name => 'Viikin Biokeskus 3'
VotingArea.create! :code => 'XIIII', :name => 'Viikin EE-talo' # Not XVIII?!
VotingArea.create! :code => 'XIX', :name => 'Ympäristöekologian'
VotingArea.create! :code => 'XX', :name => 'Vaasan yliopisto'
VotingArea.create! :code => 'E I', :name => 'Porthania'
VotingArea.create! :code => 'E II', :name => 'Viikin Infokeskus'
VotingArea.create! :code => 'E III', :name => 'Physicum'
VotingArea.create! :code => 'E IV', :name => 'Terveystieteiden keskus'
VotingArea.create! :code => 'E V', :name => 'Unicafe'

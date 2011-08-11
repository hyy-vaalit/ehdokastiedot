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
AdminUser.create!(:email => 'mark@example.com',   :password => 'password',  :password_confirmation => 'password',  :role => 'secretary')


# Voting areas
VotingArea.create! :code => 'I',      :name => 'Unicafe Ylioppilasaukio',    :password => 'pass123'
VotingArea.create! :code => 'II',     :name => 'Yliopiston päärakennus',     :password => 'pass123'
VotingArea.create! :code => 'III',    :name => 'Yliopiston päärakennus',     :password => 'pass123'
VotingArea.create! :code => 'IV',     :name => 'Porthania',                  :password => 'pass123'
VotingArea.create! :code => 'V',      :name => 'Porthania',                  :password => 'pass123'
VotingArea.create! :code => 'VI',     :name => 'Oppimiskeskus Aleksandria',  :password => 'pass123'
VotingArea.create! :code => 'VII',    :name => 'Topelia',                    :password => 'pass123'
VotingArea.create! :code => 'VIII',   :name => 'Metsätalo',                  :password => 'pass123'
VotingArea.create! :code => 'IX',     :name => 'Valtiotieteellisen tdk:n',   :password => 'pass123'
VotingArea.create! :code => 'X',      :name => 'Oppimiskeskus Minerva',      :password => 'pass123'
VotingArea.create! :code => 'XI',     :name => 'Terveystieteiden keskus',    :password => 'pass123'
VotingArea.create! :code => 'XII',    :name => 'Hammaslääketieteen',         :password => 'pass123'
VotingArea.create! :code => 'XIII',   :name => 'Physicum',                   :password => 'pass123'
VotingArea.create! :code => 'XIV',    :name => 'Chemicum',                   :password => 'pass123'
VotingArea.create! :code => 'XV',     :name => 'Exactum',                    :password => 'pass123'
VotingArea.create! :code => 'XVI',    :name => 'Viikin Infokeskus',          :password => 'pass123'
VotingArea.create! :code => 'XVII',   :name => 'Viikin Biokeskus 3',         :password => 'pass123'
VotingArea.create! :code => 'XIIII',  :name => 'Viikin EE-talo',             :password => 'pass123' # Not XVIII?!
VotingArea.create! :code => 'XIX',    :name => 'Ympäristöekologian',         :password => 'pass123'
VotingArea.create! :code => 'XX',     :name => 'Vaasan yliopisto',           :password => 'pass123'
VotingArea.create! :code => 'E I',    :name => 'Porthania',                  :password => 'pass123'
VotingArea.create! :code => 'E II',   :name => 'Viikin Infokeskus',          :password => 'pass123'
VotingArea.create! :code => 'E III',  :name => 'Physicum',                   :password => 'pass123'
VotingArea.create! :code => 'E IV',   :name => 'Terveystieteiden keskus',    :password => 'pass123'
VotingArea.create! :code => 'E V',    :name => 'Unicafe',                    :password => 'pass123'

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

# Test users
AdminUser.create!(:email => 'mark@example.com',   :password => 'password',  :password_confirmation => 'password',  :role => 'secretary')

# Create faculties
Faculty.create! :code => 'B',   :name => 'Biotieteellinen'
Faculty.create! :code => 'E',   :name => 'Eläinlääketieteellinen'
Faculty.create! :code => 'F',   :name => 'Farmasia'
Faculty.create! :code => 'H',   :name => 'Humanistinen'
Faculty.create! :code => 'K',   :name => 'Käyttäytymistieteellinen'
Faculty.create! :code => 'L',   :name => 'Lääketieteellinen'
Faculty.create! :code => 'ML',  :name => 'Matemaattis-luonnontieteellinen'
Faculty.create! :code => 'MM',  :name => 'Maa- ja metsätieteellinen'
Faculty.create! :code => 'O',   :name => 'Oikeustieteellinen'
Faculty.create! :code => 'T',   :name => 'Teologinen'
Faculty.create! :code => 'V',   :name => 'Valtiotieteellinen'


# Voting areas
VotingArea.create! :code => '1',   :name => 'Unicafe Ylioppilasaukio',    :password => 'pass123'
VotingArea.create! :code => '2',   :name => 'Yliopiston päärakennus',     :password => 'pass123'
VotingArea.create! :code => '3',   :name => 'Yliopiston päärakennus',     :password => 'pass123'
VotingArea.create! :code => '4',   :name => 'Porthania',                  :password => 'pass123'
VotingArea.create! :code => '5',   :name => 'Porthania',                  :password => 'pass123'
VotingArea.create! :code => '6',   :name => 'Oppimiskeskus Aleksandria',  :password => 'pass123'
VotingArea.create! :code => '7',   :name => 'Topelia',                    :password => 'pass123'
VotingArea.create! :code => '8',   :name => 'Metsätalo',                  :password => 'pass123'
VotingArea.create! :code => '9',   :name => 'Valtiotieteellisen tdk:n',   :password => 'pass123'
VotingArea.create! :code => '10',  :name => 'Oppimiskeskus Minerva',      :password => 'pass123'
VotingArea.create! :code => '11',  :name => 'Terveystieteiden keskus',    :password => 'pass123'
VotingArea.create! :code => '12',  :name => 'Hammaslääketieteen',         :password => 'pass123'
VotingArea.create! :code => '13',  :name => 'Physicum',                   :password => 'pass123'
VotingArea.create! :code => '14',  :name => 'Chemicum',                   :password => 'pass123'
VotingArea.create! :code => '15',  :name => 'Exactum',                    :password => 'pass123'
VotingArea.create! :code => '16',  :name => 'Viikin Infokeskus',          :password => 'pass123'
VotingArea.create! :code => '17',  :name => 'Viikin Biokeskus 3',         :password => 'pass123'
VotingArea.create! :code => '18',  :name => 'Viikin EE-talo',             :password => 'pass123'
VotingArea.create! :code => '19',  :name => 'Ympäristöekologian',         :password => 'pass123'
VotingArea.create! :code => '20',  :name => 'Vaasan yliopisto',           :password => 'pass123'
VotingArea.create! :code => 'E1',  :name => 'Porthania',                  :password => 'pass123'
VotingArea.create! :code => 'E2',  :name => 'Viikin Infokeskus',          :password => 'pass123'
VotingArea.create! :code => 'E3',  :name => 'Physicum',                   :password => 'pass123'
VotingArea.create! :code => 'E4',  :name => 'Terveystieteiden keskus',    :password => 'pass123'
VotingArea.create! :code => 'E5',  :name => 'Unicafe',                    :password => 'pass123'

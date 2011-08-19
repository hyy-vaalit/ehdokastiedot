# coding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# Clean database
#DatabaseCleaner.strategy = :truncation
#DatabaseCleaner.clean

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


# Electoral Coalition
hyal = ElectoralCoalition.create! :name => 'Ainejärjestöjen vaalirengas',                  :shorten => 'HYAL'
osak = ElectoralCoalition.create! :name => 'Osakuntien suuri vaalirengas',                 :shorten => 'Osak'
mp = ElectoralCoalition.create! :name => 'Maailmanpyörä',                                  :shorten => 'MP'
help = ElectoralCoalition.create! :name => 'HELP',                                         :shorten => 'HELP'
pelast = ElectoralCoalition.create! :name => 'Pelastusrengas',                             :shorten => 'Pelast'
snaf = ElectoralCoalition.create! :name => 'Svenska Nationer och Ämnesföreningar (SNÄf)',  :shorten => 'SNÄf'

# Single alliance coalitions
demarit = ElectoralCoalition.create! :name => 'Opiskelijademarit',            :shorten => 'OSY'
tsemppi = ElectoralCoalition.create! :name => 'Tsemppi Group',                :shorten => 'Tsempp'
piraatit = ElectoralCoalition.create! :name => 'Akateemiset piraatit',        :shorten => 'Pirate'
persut = ElectoralCoalition.create! :name => 'Perussuomalainen vaaliliitto',  :shorten => 'Peruss'
amnes = ElectoralCoalition.create! :name => 'Ämnesföreningarna',              :shorten => 'Ämnesf'

# Electoral Alliances
mp.electoral_alliances.create! :name => 'HYYn Vihreät - De Gröna vid HUS',                               :shorten => 'HyVi'
mp.electoral_alliances.create! :name => 'Sitoutumaton vasemmisto - Obunden vänster - Independent left',  :shorten => 'SitVas'
hyal.electoral_alliances.create! :name => 'Humanistit',                                                  :shorten => 'Humani'
help.electoral_alliances.create! :name => 'Viikki',                                                      :shorten => 'Viikki'
hyal.electoral_alliances.create! :name => 'Pykälä',                                                      :shorten => 'Pykälä'
hyal.electoral_alliances.create! :name => 'Kumpula',                                                     :shorten => 'Kumpul'
help.electoral_alliances.create! :name => 'LKS/HLKS',                                                    :shorten => 'LKSHLK'
hyal.electoral_alliances.create! :name => 'Käyttis',                                                     :shorten => 'Käytti'
osak.electoral_alliances.create! :name => 'ESO',                                                         :shorten => 'ESO'
pelast.electoral_alliances.create! :name => 'Kokoomusopiskelijat 1',                                     :shorten => 'Kok1'
help.electoral_alliances.create! :name => 'EKY',                                                         :shorten => 'EKY'
hyal.electoral_alliances.create! :name => 'Valtiotieteilijät',                                           :shorten => 'Valtio'
hyal.electoral_alliances.create! :name => 'Teologit',                                                    :shorten => 'Teolog'
osak.electoral_alliances.create! :name => 'HO-Natura',                                                   :shorten => 'HO-Nat'
osak.electoral_alliances.create! :name => 'EPO',                                                         :shorten => 'EPO'
pelast.electoral_alliances.create! :name => 'Kokoomusopiskelijat 2',                                     :shorten => 'Kok2'
osak.electoral_alliances.create! :name => 'Domus Gaudiumin Osakunnat',                                   :shorten => 'DG'
osak.electoral_alliances.create! :name => 'PPO',                                                         :shorten => 'PPO'
pelast.electoral_alliances.create! :name => 'Keskeiset',                                                 :shorten => 'Kesk'
osak.electoral_alliances.create! :name => 'SavO',                                                        :shorten => 'SavO'
osak.electoral_alliances.create! :name => 'KSO-VSO',                                                     :shorten => 'KSOVSO'
demarit.electoral_alliances.create! :name => 'Opiskelijademarit',                                        :shorten => 'OSY'
snaf.electoral_alliances.create! :name => 'StudOrg',                                                     :shorten => 'StudO'
osak.electoral_alliances.create! :name => 'SatO-ESO2',                                                   :shorten => 'SatESO'
snaf.electoral_alliances.create! :name => 'Nationerna',                                                  :shorten => 'Nation'
tsemppi.electoral_alliances.create! :name => 'Tsemppi Group',                                            :shorten => 'Tsempp'
snaf.electoral_alliances.create! :name => 'Codex-Thorax',                                                :shorten => 'CodTho'
pelast.electoral_alliances.create! :name => 'KD Helsingin Opiskelijat',                                  :shorten => 'KD'
piraatit.electoral_alliances.create! :name => 'Akateemiset piraatit',                                    :shorten => 'Pirate'
persut.electoral_alliances.create! :name => 'Perussuomalainen vaaliliitto',                              :shorten => 'Peruss'
amnes.electoral_alliances.create! :name => 'Ämnesföreningarna',                                          :shorten => 'Ämnesf'
snaf.electoral_alliances.create! :name => 'Liberaalinen vaaliliitto - Yksilönvapauden puolesta',         :shorten => 'Libera'


# Configurations
REDIS.set 'total_vote_count', '9999999999'
REDIS.set 'right_to_vote', '9999999999'
REDIS.set 'candidates_to_select', '9999999999'
REDIS.set 'mailaddress', 'hostmaster-hyy@enemy.fi'

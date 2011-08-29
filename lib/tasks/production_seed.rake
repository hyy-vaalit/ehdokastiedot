# coding: UTF-8

namespace :production_seed do

  desc 'Seed data for faculties'
  task :faculties => :environment do
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
  end

  desc 'Seed data for voting areas'
  task :voting_areas => :environment do
    puts 'Seeding voting areas ...'

    puts '#TODO: add passwords'
    VotingArea.create! :code => 'I', :name => 'Unicafe Ylioppilasaukio', :password => ''
    VotingArea.create! :code => 'II', :name => 'Yliopiston päärakennus', :password => ''
    VotingArea.create! :code => 'III', :name => 'Yliopiston päärakennus', :password => ''
    VotingArea.create! :code => 'IV', :name => 'Porthania', :password => ''
    VotingArea.create! :code => 'V', :name => 'Metsätalo', :password => ''
    VotingArea.create! :code => 'VI', :name => 'Valtiotieteellisen tiedekunnan kirjasto', :password => ''
    VotingArea.create! :code => 'VII', :name => 'Oppimiskeskus Minerva', :password => ''
    VotingArea.create! :code => 'VIII', :name => 'Terveystieteiden keskuskirjasto', :password => ''
    VotingArea.create! :code => 'IX', :name => 'Hammaslääketieteen laitos', :password => ''
    VotingArea.create! :code => 'X', :name => 'Physicum', :password => ''
    VotingArea.create! :code => 'XI', :name => 'Exactum', :password => ''
    VotingArea.create! :code => 'XII', :name => 'Infokeskus', :password => ''
    VotingArea.create! :code => 'XIII', :name => 'EE-talo', :password => ''
    VotingArea.create! :code => 'XIV', :name => 'Ympäristöekologian laitos', :password => ''
    VotingArea.create! :code => 'XV', :name => 'Vaasan yliopisto', :password => ''
    VotingArea.create! :code => 'E I', :name => 'Keskustakampus, Porthania', :password => ''
    VotingArea.create! :code => 'E II', :name => 'Viikin kampus, Infokeskus', :password => ''
    VotingArea.create! :code => 'E III', :name => 'Kumpulan kampus, Physicum', :password => ''
    VotingArea.create! :code => 'E IV', :name => 'Meilahden kampus, Terveystieteiden keskuskirjasto', :password => ''
  end

end

desc 'Runs production seed data'
task :production_seed do
  Rake::Task['production_seed:faculties'].invoke
  Rake::Task['production_seed:voting_areas'].invoke
end

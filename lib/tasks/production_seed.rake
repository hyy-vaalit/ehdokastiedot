# coding: UTF-8

namespace :production_seed do

  desc 'Seed data for faculties'
  task :faculties => :environment do
    puts 'Seeding faculties ...'
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

    #raise 'Add passwords and remove this line (production_seed.rake). PS. Plz commit them to github too, ok!'
    VotingArea.create! :code => 'I', :name => 'Unicafe Ylioppilasaukio', :password => 'salainensana'
    VotingArea.create! :code => 'II', :name => 'Yliopiston päärakennus', :password => 'salainensana'
    VotingArea.create! :code => 'III', :name => 'Yliopiston päärakennus', :password => 'salainensana'
    VotingArea.create! :code => 'IV', :name => 'Porthania', :password => 'salainensana'
    VotingArea.create! :code => 'V', :name => 'Metsätalo', :password => 'salainensana'
    VotingArea.create! :code => 'VI', :name => 'Valtiotieteellisen tiedekunnan kirjasto', :password => 'salainensana'
    VotingArea.create! :code => 'VII', :name => 'Oppimiskeskus Minerva', :password => 'salainensana'
    VotingArea.create! :code => 'VIII', :name => 'Terveystieteiden keskuskirjasto', :password => 'salainensana'
    VotingArea.create! :code => 'IX', :name => 'Hammaslääketieteen laitos', :password => 'salainensana'
    VotingArea.create! :code => 'X', :name => 'Physicum', :password => 'salainensana'
    VotingArea.create! :code => 'XI', :name => 'Exactum', :password => 'salainensana'
    VotingArea.create! :code => 'XII', :name => 'Infokeskus', :password => 'salainensana'
    VotingArea.create! :code => 'XIII', :name => 'EE-talo', :password => 'salainensana'
    VotingArea.create! :code => 'XIV', :name => 'Ympäristöekologian laitos', :password => 'salainensana'
    VotingArea.create! :code => 'XV', :name => 'Vaasan yliopisto', :password => 'salainensana'
    VotingArea.create! :code => 'E I', :name => 'Keskustakampus, Porthania', :password => 'salainensana'
    VotingArea.create! :code => 'E II', :name => 'Viikin kampus, Infokeskus', :password => 'salainensana'
    VotingArea.create! :code => 'E III', :name => 'Kumpulan kampus, Physicum', :password => 'salainensana'
    VotingArea.create! :code => 'E IV', :name => 'Meilahden kampus, Terveystieteiden keskuskirjasto', :password => 'salainensana'
  end

  desc 'Setup production configuration defaults'
  task :defaults => :environment do
    REDIS.set 'mailaddress', 'vaalit@hyy.fi'
    REDIS.set 'total_vote_count', '0'
    REDIS.set 'right_to_vote', '0'
    REDIS.set 'candidates_to_select', '60'
    REDIS.set 'spare_candidates_to_select', '2'
    REDIS.set 'checking_minutes_username', 'tlkpj'
    REDIS.set 'checking_minutes_password', 'salainensana'

    AdminUser.create!(:email => 'emma.ronkainen@hyy.fi', :password => 'salainensana', :password_confirmation => 'salainensana', :role => 'admin')
  end
end

desc 'Runs production seed data'
task :production_seed do
  Rake::Task['production_seed:faculties'].invoke
  Rake::Task['production_seed:voting_areas'].invoke
  Rake::Task['production_seed:defaults'].invoke
end

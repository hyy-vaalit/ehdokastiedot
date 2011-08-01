# coding: UTF-8
require 'csv'

namespace :csv_seed do

  desc 'Create candidate data from seed.csv'
  task :candidates => :environment do
    csv_contents = CSV.read('doc/vaalit_2009_ehdokkaat.csv')
    csv_contents.shift
    csv_contents.each do |row|

      faculty = Faculty.find_or_create_by_code row[4]
      electoral_coalition = ElectoralCoalition.find_or_create_by_name row[9]
      electoral_alliance = ElectoralAlliance.find_or_create_by_name_and_electoral_coalition_id (row[11] || row[8]), electoral_coalition.id
      electoral_alliance.update_attribute :signing_order_position, row[10]

      def generate_ssn
        @@order = (@@order ||= 0) + 1
        @@days   ||= (1..31).to_a
        @@months ||= (1..12).to_a
        @@years  ||= (50..90).to_a
        @@check  ||= '0123456789ABCDEFHJKLMNPRSTUVWXY'

        day   = sprintf "%02d", @@days[rand(@@days.length)]
        month = sprintf "%02d", @@months[rand(@@months.length)]
        year  = sprintf "%02d", @@years[rand(@@years.length)]
        order = sprintf "%03d", @@order
        check = @@check[("#{day}#{month}#{year}#{order}".to_i) % 31]

        "#{day}#{month}#{year}-#{order}#{check}"

      end

      candidate = Candidate.create! :candidate_number       => row[0],
                                    :lastname               => row[1],
                                    :firstname              => row[2],
                                    :social_security_number => (row[3] || generate_ssn),
                                    :faculty                => faculty,
                                    :address                => row[5],
                                    :postal_information     => row[6],
                                    :email                  => row[7],
                                    :candidate_name         => row[8],
                                    :electoral_alliance     => electoral_alliance,
                                    :sign_up_order_position => row[12],
                                    :notes                  => row[13]
    end
  end

  desc 'Create early voting data'
  task :early_voting => :environment do
    (1..5).to_a.each do |i|
      voting_area = VotingArea.create! :code => "E#{i}", :name => "Ennakkoäänetyspaikka #{1}", :password => 'foobar123'
      csv_contents = CSV.read("doc/votes/E#{i}")
      csv_contents.shift
      csv_contents.each do |row|
        Candidate.find_by_candidate_number(row[0]).votes.create! :voting_area => voting_area, :vote_count => row[3]
      end
    end
  end

  desc 'Create main voting data'
  task :main_voting => :environment do
    voting_area = VotingArea.create! :code => 'DEF', :name => 'Default', :password => 'foobar123'
    csv_contents = CSV.read('doc/votes/HYY09')
    csv_contents.shift
    csv_contents.each do |row|
      Candidate.find_by_candidate_number(row[0]).votes.create! :voting_area => voting_area, :vote_count => row[3]
    end
  end

end

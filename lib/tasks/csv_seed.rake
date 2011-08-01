# coding: UTF-8
namespace :csv_seed do

  desc 'Create candidate data from seed.csv'
  task :candidates => :environment do
    require 'csv'
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

end

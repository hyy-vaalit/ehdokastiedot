namespace :db do
  namespace :seed do
    desc 'Seed a complete development data set.'
    task :dev do
      Rake::Task['db:seed:development:configuration'].invoke
      Rake::Task['db:seed:development:create_advocates'].invoke
      Rake::Task['db:seed:development:faculties'].invoke
      Rake::Task['db:seed:development:electoral'].invoke
      Rake::Task['db:seed:development:candidates'].invoke
    end

    namespace :development do
      def random_advocate_user(number)
        (number % 2 == 0) ? AdvocateUser.first : AdvocateUser.last
      end

      def create_alliance!(coalition, opts)
        alliance = coalition.electoral_alliances.build(opts)
        alliance.advocate_user = random_advocate_user(coalition.id)

        alliance.save!
      end

      def create_candidate!(alliance, faculty, candidate_number, opts)
        candidate = alliance.candidates.build(opts)
        candidate.faculty = faculty
        candidate.candidate_number = candidate_number

        candidate.save!
      end

      desc 'Default project settings'
      task :configuration => :environment do
        puts 'Creating GlobalConfiguration'

        GlobalConfiguration.create!(
          advocate_login_enabled: true
        )

        AdminUser.create!(:email => 'admin@example.com', :password => 'pass123', :password_confirmation => 'pass123', :role => 'admin')
        AdminUser.create!(:email => 'sihteeri@example.com', :password => 'pass123', :password_confirmation => 'pass123', :role => 'secretary')
      end

      desc 'Create faculties'
      task :faculties => :environment do
        puts 'Creating Faculties (acually departments)'

        Faculty.create! code: 'T', numeric_code: 10, name: 'Teologinen'
        Faculty.create! code: 'O', numeric_code: 20, name: 'Oikeustieteellinen'
        Faculty.create! code: 'L', numeric_code: 30, name: 'Lääketieteellinen'
        Faculty.create! code: 'H', numeric_code: 40, name: 'Humanistinen'
        Faculty.create! code: 'ML',numeric_code: 50, name: 'Matemaattis-luonnontieteellinen'
        Faculty.create! code: 'F', numeric_code: 55, name: 'Farmasia'
        Faculty.create! code: 'B', numeric_code: 57, name: 'Bio- ja ympäristötieteellinen'
        Faculty.create! code: 'K', numeric_code: 60, name: 'Kasvatustieteellinen'
        Faculty.create! code: 'V', numeric_code: 70, name: 'Valtiotieteellinen'
        Faculty.create! code: 'S', numeric_code: 74, name: 'Svenska social- och kommunalhögskolan'
        Faculty.create! code: 'MM',numeric_code: 80, name: 'Maatalous- ja metsätieteellinen'
        Faculty.create! code: 'E', numeric_code: 90, name: 'Eläinlääketieteellinen'
      end

      desc 'Create electoral coalitions and alliances'
      task :electoral => :environment do
        # Electoral Coalition
        puts 'Creating Coalitions'

        hyal = ElectoralCoalition.create! :name => 'Ainejärjestöjen vaalirengas',                  :shorten => 'HYAL', :numbering_order => "10"
        osak = ElectoralCoalition.create! :name => 'Osakuntien suuri vaalirengas',                 :shorten => 'Osak', :numbering_order => "9"
        mp = ElectoralCoalition.create! :name => 'Maailmanpyörä',                                  :shorten => 'MP', :numbering_order => "8"
        help = ElectoralCoalition.create! :name => 'HELP',                                         :shorten => 'HELP', :numbering_order => "6"
        pelast = ElectoralCoalition.create! :name => 'Pelastusrengas',                             :shorten => 'Pelast', :numbering_order => "4"
        snaf = ElectoralCoalition.create! :name => 'Svenska Nationer och Ämnesföreningar (SNÄf)',  :shorten => 'SNÄf', :numbering_order => "5"

        # Single alliance coalitions
        demarit = ElectoralCoalition.create! :name => 'Opiskelijademarit',            :shorten => 'OSY', :numbering_order => "3"
        tsemppi = ElectoralCoalition.create! :name => 'Tsemppi Group',                :shorten => 'Tsempp', :numbering_order => "2"
        piraatit = ElectoralCoalition.create! :name => 'Akateemiset piraatit',        :shorten => 'Pirate', :numbering_order => "1"
        persut = ElectoralCoalition.create! :name => 'Perussuomalainen vaaliliitto',  :shorten => 'Peruss', :numbering_order => "7"
        libera = ElectoralCoalition.create! :name => 'Liberaalinen vaaliliitto - Yksilönvapauden puolesta',  :shorten => 'Libera', :numbering_order => "5"
        ite1 = ElectoralCoalition.create! :name => 'Itsenäinen ehdokas 1',  :shorten => 'ITE1', :numbering_order => "11"

        # Electoral Alliances
        puts 'Creating Alliances'

        create_alliance! mp, :name => 'HYYn Vihreät - De Gröna vid HUS',                              :shorten => 'HyVi',   :expected_candidate_count => '60'
        create_alliance! mp, :name => 'Sitoutumaton vasemmisto - Obunden vänster - Independent left', :shorten => 'SitVas', :expected_candidate_count => '60'

        create_alliance! hyal, :name => 'Humanistit',  :shorten => 'Humani', :expected_candidate_count => '40'
        create_alliance! hyal, :name => 'Viikki',      :shorten => 'Viikki', :expected_candidate_count => '16'

        create_alliance! help, :name => 'Pykälä',      :shorten => 'Pykälä', :expected_candidate_count => '44'
        create_alliance! hyal, :name => 'Kumpula',     :shorten => 'Kumpul', :expected_candidate_count => '17'
        create_alliance! help, :name => 'LKS / HLKS',                                                    :shorten => 'LKSHLK',  :expected_candidate_count => '15'
        create_alliance! hyal, :name => 'Käyttis',                                                     :shorten => 'Käytti',  :expected_candidate_count => '12'
        create_alliance! osak, :name => 'ESO',                                                         :shorten => 'ESO',     :expected_candidate_count => '60'
        create_alliance! pelast, :name => 'Kokoomusopiskelijat 1',                                     :shorten => 'Kok1',    :expected_candidate_count => '49'
        create_alliance! help, :name => 'EKY',                                                         :shorten => 'EKY',     :expected_candidate_count => '16'
        create_alliance! hyal, :name => 'Valtiotieteilijät',                                           :shorten => 'Valtio',  :expected_candidate_count => '16'
        create_alliance! hyal, :name => 'Teologit',                                                    :shorten => 'Teolog',  :expected_candidate_count => '26'
        create_alliance! osak, :name => 'HO-Natura',                                                   :shorten => 'HO-Nat',  :expected_candidate_count => '39'
        create_alliance! osak, :name => 'EPO',                                                         :shorten => 'EPO',     :expected_candidate_count => '57'
        create_alliance! pelast, :name => 'Kokoomusopiskelijat 2',                                     :shorten => 'Kok2',    :expected_candidate_count => '49'
        create_alliance! osak, :name => 'Domus Gaudiumin osakunnat',                                   :shorten => 'DG',      :expected_candidate_count => '44'
        create_alliance! osak, :name => 'PPO',                                                         :shorten => 'PPO',     :expected_candidate_count => '42'
        create_alliance! pelast, :name => 'Keskeiset',                                                 :shorten => 'Kesk',    :expected_candidate_count => '18'
        create_alliance! osak, :name => 'SavO',                                                        :shorten => 'SavO',    :expected_candidate_count => '42'
        create_alliance! osak, :name => 'KSO-VSO',                                                     :shorten => 'KSOVSO',  :expected_candidate_count => '29'
        create_alliance! demarit, :name => 'Opiskelijademarit',                                        :shorten => 'OSY',     :expected_candidate_count => '32'
        create_alliance! snaf, :name => 'StudOrg',                                                     :shorten => 'StudO',   :expected_candidate_count => '12'
        create_alliance! osak, :name => 'SatO-ESO2',                                                   :shorten => 'SatESO',  :expected_candidate_count => '43'
        create_alliance! snaf, :name => 'Nationerna',                                                  :shorten => 'Nation',  :expected_candidate_count => '18'
        create_alliance! tsemppi, :name => 'Tsemppi Group',                                            :shorten => 'Tsempp',  :expected_candidate_count => '15'
        create_alliance! snaf, :name => 'Codex-Thorax',                                                :shorten => 'CodTho',  :expected_candidate_count => '8'
        create_alliance! pelast, :name => 'KD Helsingin opiskelijat',                                  :shorten => 'KD',      :expected_candidate_count => '14'
        create_alliance! piraatit, :name => 'Akateemiset piraatit',                                    :shorten => 'Pirate',  :expected_candidate_count => '4'
        create_alliance! persut, :name => 'Perussuomalainen vaaliliitto',                              :shorten => 'Peruss',  :expected_candidate_count => '3'
        create_alliance! snaf, :name => 'Ämnesföreningarna',                                          :shorten => 'Ämnesf',  :expected_candidate_count => '4'
        create_alliance! libera, :name => 'Liberaalinen vaaliliitto - yksilönvapauden puolesta',         :shorten => 'Libera',  :expected_candidate_count => '3'
        create_alliance! ite1, :name => 'Itsenäinen ehdokas 1',         :shorten => 'ITE1',  :expected_candidate_count => '1'
      end

      desc 'Create advocate users'
      task :create_advocates => :environment do
        puts 'Creating AdvocateUsers'

        AdvocateUser.create! :firstname => "Rami", :lastname => "Raavas", :ssn => '123456-123K', :email => 'edustaja1@example.com', :password => 'pass123', :password_confirmation => 'pass123'
        AdvocateUser.create! :firstname => "Laura", :lastname => "Lanttunen", :ssn => '123456-9876', :email => 'edustaja2@example.com', :password => 'pass123', :password_confirmation => 'pass123'
      end

      desc 'Create candidate data from seed.csv'
      task :candidates => :environment do
        Candidate.transaction do
          puts 'Creating candidates'
          csv_contents = CSV.read('doc/vaalit_2009_ehdokkaat.csv', encoding: "UTF-8")
          csv_contents.shift
          csv_contents.each do |row|

            faculty = Faculty.find_or_create_by code: row[4]

            alliance_name = (row[11] || row[8])
            electoral_alliance = ElectoralAlliance.find_by_name alliance_name
            unless electoral_alliance
              electoral_coalition = ElectoralCoalition.find_or_create_by(name: row[9]) if row[9]
              electoral_coalition = ElectoralCoalition.create! :name => alliance_name unless electoral_coalition
              electoral_alliance = create_alliance!(electoral_coalition, :name => alliance_name, :expected_candidate_count => 0)
            end
            electoral_alliance.update_attribute :numbering_order_position, row[10]

            def generate_ssn
              seed   = rand(100)
              days   = (1..31).to_a
              months = (1..12).to_a
              years  = (50..90).to_a
              checks = '0123456789ABCDEFHJKLMNPRSTUVWXY'

              day   = sprintf "%02d", days[rand(days.length)]
              month = sprintf "%02d", months[rand(months.length)]
              year  = sprintf "%02d", years[rand(years.length)]
              order = sprintf "%03d", seed
              check = checks[("#{day}#{month}#{year}#{order}".to_i) % 31]

              "#{day}#{month}#{year}-#{order}#{check}"

            end

            create_candidate!(electoral_alliance, faculty, row[0],
                                          :lastname               => row[1],
                                          :firstname              => row[2],
                                          :social_security_number => (row[3] || generate_ssn),
                                          :address                => row[5],
                                          :postal_information     => row[6],
                                          :email                  => "#{row[7].split('@')[0]}@example.com",
                                          :candidate_name         => row[8],
                                          :numbering_order_position => row[12],
                                          :notes                  => row[13])
          end
        end
      end
    end
  end
end

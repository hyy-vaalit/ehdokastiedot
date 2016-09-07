namespace :db do
  namespace :seed do
    desc 'Seed initial production data (required for deployment!)'
    task :production do
      Rake::Task['db:seed:production:faculties'].invoke
      Rake::Task['db:seed:production:configuration'].invoke
      Rake::Task['db:seed:admin_users'].invoke
    end

    namespace :production do
      desc 'Seed data for faculties'
      task :faculties => :environment do
        puts 'Seeding faculties ...'
        Faculty.create! code: 'T', numeric_code: 10, name: 'Teologinen'
        Faculty.create! code: 'O', numeric_code: 20, name: 'Oikeustieteellinen'
        Faculty.create! code: 'L', numeric_code: 30, name: 'Lääketieteellinen'
        Faculty.create! code: 'H', numeric_code: 40, name: 'Humanistinen'
        Faculty.create! code: 'ML',numeric_code: 50, name: 'Matemaattis-luonnontieteellinen'
        Faculty.create! code: 'F', numeric_code: 55, name: 'Farmasia'
        Faculty.create! code: 'B', numeric_code: 57, name: 'Biotieteellinen'
        Faculty.create! code: 'K', numeric_code: 60, name: 'Käyttäytymistieteellinen'
        Faculty.create! code: 'V', numeric_code: 70, name: 'Valtiotieteellinen'
        Faculty.create! code: 'S', numeric_code: 74, name: 'Svenska social- och kommunalhögskolan'
        Faculty.create! code: 'MM',numeric_code: 80, name: 'Maatalous- ja metsätieteellinen'
        Faculty.create! code: 'E', numeric_code: 90, name: 'Eläinlääketieteellinen'
      end

      desc 'Setup production configuration defaults'
      task :configuration => :environment do
        conf = GlobalConfiguration.new
        conf.advocate_login_enabled       = false

        # Käytetään vain uurnavaalissa, jossa suoritetaan tarkastuslaskenta.
        # Disable in .env using CHECKING_MINUTES_ENABLED
        conf.checking_minutes_username    = 'tlkpj'
        conf.checking_minutes_password    = Devise.friendly_token.first(8)
        conf.save!
      end
    end
  end
end

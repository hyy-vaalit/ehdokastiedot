namespace :db do
  namespace :seed do

    desc 'Create Admin users and deliver password by email'
    task admin_users: :environment do
      Rails.logger.info 'Create Admin users'

      puts '---------------- ADMIN USER EMAILS ----------------'
      puts 'Give email where the password will be mailed to.'
      puts 'User will be created after you press enter.'
      puts 'You can enter multiple addressed.'
      puts ''
      puts 'End with ^D'
      puts ''
      puts 'Emails:'

      count = 0

      $stdin.each do |email|
        count = count + 1
        admin = AdminUser.create!(email: email, role: 'admin')
        puts "Created #{admin.email} (id: #{admin.id})"
        puts 'Give next email, end with ^D'
      end

      Rails.logger.info "Created #{count} Admin users"
      puts "Created #{count} Admin users"
    end
  end
end

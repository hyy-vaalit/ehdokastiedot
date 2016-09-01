namespace :db do
  desc 'Reset development environment as in destroy and recreate database.'
  task :runts do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:schema:load'].invoke

    puts ''
    puts 'Next: `rake -T db:seed` or just run:'
    puts '  rake db:seed:dev'
  end
end

desc 'Reset development environment as in destroy and recreate everything.'
task :runts do
  Rake::Task['db:drop'].invoke
  Rake::Task['db:create'].invoke
  Rake::Task['db:schema:load'].invoke
  Rake::Task['seed:development'].invoke
end
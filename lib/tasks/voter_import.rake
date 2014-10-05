
namespace :voters do

  desc 'Import voters from given file in Opiskelijarekisteri format'
  task :import, [:filename] => :environment do
    unless filename=ENV['filename']
      puts "Missing parameter: filename=import_file.txt"
      exit 1
    end

    puts "Import voters from: #{filename}"

    file = File.new(filename, "r")

    while (line = file.gets) do
      ImportedVoter.new :data => line
    end

  end

end

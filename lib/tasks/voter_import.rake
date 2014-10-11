
namespace :voters do

  desc 'Import voters from given file in Opiskelijarekisteri format'
  task :import, [:filename] => :environment do
    unless filename=ENV['filename']
      puts "Missing parameter: filename=import_file.txt"
      exit 1
    end

    encoding = 'ISO-8859-1'
    puts "Import voters from: #{filename} using encoding: #{encoding}"

    file = File.new(filename, "r", :encoding => encoding)

    lines = 0
    puts "BEGIN: Database has now #{Voter.count} voters."

    ActiveRecord::Base.transaction do
      begin

        while (line_of_data = file.gets) do
          next if line_of_data.blank?

          lines = lines + 1

          imported_voter = ImportedVoter.build_from(line_of_data)
          puts "Line #{lines} - #{imported_voter.name}"

          Voter.create_from!(imported_voter)
        end

        puts "Imported #{lines} voters from file."

      rescue Exception => e
        puts "Error: #{e}"
        raise ActiveRecord::Rollback
      end

    end # Transaction

    puts "END: Database has now #{Voter.count} voters."
  end

end

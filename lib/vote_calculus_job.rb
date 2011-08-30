class VoteCalculusJob < Struct.new(:voting_area_ids)

  def perform
    puts "Starting VoteCalculusJob with ids: #{voting_area_ids.inspect}"
    puts REDIS.inspect
    puts "Starting Proportionals.calculus!"
    Proportionals.calculus!
    puts "Starting ResultPage.render_results"
    ResultPage.render_results
    puts "Marking voting areas as calculated"
    voting_area_ids.each do |id|
      puts "Marking voting area #{id.inspect} as calculated"
      VotingArea.find_by_id(id).mark_as_calculated!
    end
  end

end

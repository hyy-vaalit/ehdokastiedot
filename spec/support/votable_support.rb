module VotableSupport

  def self.create_votes_for_alliance(alliance, amount, voting_areas)
    alliance.candidates.each { |c| create_votes_for_candidate(c, amount, voting_areas) }
  end

  def self.create_votes_for_candidate(candidate, amount, voting_areas)
    voting_areas.each do |area|
      FactoryGirl.create(:vote, :candidate => candidate, :voting_area => area, :amount => amount)
    end
  end

end
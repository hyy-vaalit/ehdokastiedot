module VotableSupport

  def self.create_votes_for_alliance(alliance, amount, voting_areas)
    alliance.candidates.each { |c| create_votes_for_candidate(c, amount, voting_areas) }
  end

  def self.create_votes_for_candidate(candidate, amount, voting_areas)
    voting_areas.each do |area|
      FactoryGirl.create(:vote, :candidate => candidate, :voting_area => area, :amount => amount)
    end
  end

  def self.create_votes_for(candidates, voting_areas, opts = {})
    opts[:base_vote_count] ||= 0
    opts[:ascending] ||= false

    voting_areas.each do |area|
      vote_amount = opts[:base_vote_count]
      candidates.each do |candidate|
        FactoryGirl.create(:vote, :candidate => candidate, :voting_area => area, :amount => vote_amount)
        opts[:ascending] ? vote_amount += 10 : vote_amount -= 10
      end
    end
  end

end
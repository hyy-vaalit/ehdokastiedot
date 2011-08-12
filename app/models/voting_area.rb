class VotingArea < ActiveRecord::Base

  has_many :votes

  attr_accessor :password

  validates_presence_of :password

  before_create :encrypt_password

  def self.authenticate code, password
    area = self.find_by_code code
    return nil if area.nil?
    return area if area.has_password? password
  end

  def total_votes
    votes.map(&:vote_count).sum
  end

  def give_votes! votes
    invalid = []
    votes.each do |i, vote|
      next if vote[:candidate_number].empty?
      begin
        candidate = Candidate.find_by_candidate_number vote[:candidate_number]
        old_vote = self.votes.find_by_candidate_id candidate.id
        if old_vote
          old_vote.update_attribute :vote_count, vote[:vote_count]
        else
          self.votes.create! :candidate => candidate, :vote_count => vote[:vote_count]
        end
      rescue
        invalid << vote[:candidate_number]
      end
    end
    raise "Check candidate numbers #{invalid.join(', ')}" unless invalid.empty?
  end

  def has_password? password
    self.encrypted_password == encrypt(password)
  end

  def ready!
    update_attribute :ready, true
  end

  private

  def encrypt_password
    self.encrypted_password = encrypt password
  end

  def encrypt(string)
    Digest::SHA2.hexdigest string
  end

end

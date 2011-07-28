class VotingArea < ActiveRecord::Base

  has_many :votes

  attr_accessor :password

  validates_presence_of :password

  before_save :encrypt_password

  def self.authenticate code, password
    area = self.find_by_code code
    return nil if area.nil?
    return area if area.has_password? password
  end

  def give_votes! votes
    invalid = []
    votes.each do |i, vote|
      next if vote[:candidate_number].empty?
      begin
        candidate = Candidate.find_by_candidate_number vote[:candidate_number]
        self.votes.create! :candidate => candidate, :vote_count => vote[:vote_count]
      rescue
        invalid << vote[:candidate_number]
      end
    end
    raise "Check candidate numbers #{invalid.join(', ')}" unless invalid.empty?
  end

  def has_password? password
    self.encrypted_password == encrypt(password)
  end

  private

  def encrypt_password
    self.encrypted_password = encrypt password
  end

  def encrypt(string)
    Digest::SHA2.hexdigest string
  end

end

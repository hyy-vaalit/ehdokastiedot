# States:
#  - "ready" when all votes have been filled to the voting area
#  - "taken" when voting area has been taken in to the voting calculations (FIXME: has been calculated or will be calculated?)

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

  def self.take! ids
    ids.each do |id|
      va = VotingArea.find_by_id(id)
      va.taken!
    end
  end

  def vote_count
    votes.sum(:amount)
  end

  def state_class
    if ready
      if taken
        if calculated
          'calculated'
        else
          'taken'
        end
      else
        'finish'
      end
    else
      'unfinished'
    end
  end

  def state
    if ready
      if taken
        if calculated
          'Laskettu'
        else
          'Laskennassa'
        end
      else
        'Valmiina laskentaan'
      end
    else
      'Kesken'
    end
  end

  def mark_as_calculated!
    self.update_attribute :calculated, true
  end

  # FIXME: Transaktio puuttuu! #18336147
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

  # FIXME: Transaktio puuttuu!
  def give_fix_votes! votes
    invalid = []
    votes.each do |i, vote|
      next if vote[:candidate_number].empty? or vote[:vote_count].empty?
      begin
        candidate = Candidate.find_by_candidate_number vote[:candidate_number]
        old_vote = self.votes.find_by_candidate_id candidate.id
        if old_vote
          if old_vote.vote_count == vote[:vote_count]
            old_vote.update_attribute :fix_count, nil
          else
            old_vote.update_attribute :fix_count, vote[:vote_count]
          end
        else
          self.votes.create! :candidate => candidate, :vote_count => 0, :fix_count => vote[:vote_count] unless vote[:vote_count] == 0
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

  def taken!
    update_attribute :taken, true
  end

  private

  def encrypt_password
    self.encrypted_password = encrypt password
  end

  def encrypt(string)
    Digest::SHA2.hexdigest string
  end

end

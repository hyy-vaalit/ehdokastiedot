# States:
#  - "ready" when all votes have been filled to the voting area
#  - "taken" when voting area has been taken in to the voting calculations (FIXME: has been calculated or will be calculated?)
#
# Good to know:
#  - marking a voting area ready does not prevent submitting new votes by the submission form if the form is visible.
class VotingArea < ActiveRecord::Base

  has_many :votes

  attr_accessor :password

  validates_presence_of :password

  before_create :encrypt_password

  scope :countable, where('ready = ?', true)
  scope :markable_as_ready, where('submitted = ?', true)
  scope :by_code, order(:code)

  def self.for_showdown
    order('ready desc, submitted desc, id asc')
  end

  def self.authenticate code, password
    area = self.find_by_code code
    return nil if area.nil?
    return area if area.has_password? password
  end

  def vote_count
    votes.sum(:amount)
  end

  def create_votes_from(vote_submissions, opts = {})
    use_fixed_amount = opts[:use_fixed_amount]

    VotingArea.transaction do
      vote_submissions.each do |index, vote|
        candidate_number = vote["candidate_number"]
        vote_amount       = vote["vote_amount"]
        next if candidate_number.blank? or vote_amount.blank?

        candidate = Candidate.find_by_candidate_number(candidate_number)

        if candidate and Vote.create_or_update_from(self.id, candidate.id, vote_amount, use_fixed_amount)
          next # success
        else
          errors.add :invalid_candidate_numbers, candidate_number
        end
      end
    end
  end

  def has_password? password
    self.encrypted_password == encrypt(password)
  end

  def ready!
    update_attribute :ready, true
  end

  def submitted!
    update_attribute :submitted, true
  end

  private

  def encrypt_password
    self.encrypted_password = encrypt password
  end

  def encrypt(string)
    Digest::SHA2.hexdigest string
  end

end

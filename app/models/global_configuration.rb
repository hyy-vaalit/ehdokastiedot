class GlobalConfiguration < ActiveRecord::Base

  attr_accessible :votes_given, :votes_accepted, :voters_count, :potential_voters_count

  def self.candidate_nomination_period_effective?
    first.candidate_nomination_period_effective?
  end

  def self.candidate_nomination_ends_at
    first.candidate_nomination_ends_at
  end

  def self.candidate_data_is_freezed_at
    first.candidate_data_is_freezed_at
  end

  def self.mail_from_address
    first.mail_from_address
  end

  def self.mail_from_name
    first.mail_from_name
  end

  def self.votes_given
    first.votes_given
  end

  def self.votes_accepted
    first.votes_accepted
  end

  def self.voters_count
    first.voters_count
  end

  def self.potential_voters_count
    first.potential_voters_count
  end

  def self.log_candidate_attribute_changes?
    not candidate_nomination_period_effective?
  end

  def self.advocate_login_enabled?
    return first.advocate_login_enabled?
  end

  def self.candidate_data_frozen?
    Time.now > candidate_data_is_freezed_at
  end

  def candidate_nomination_period_effective?
    Time.now < candidate_nomination_ends_at
  end

  def elected_candidate_count
    Vaalit::Voting::ELECTED_CANDIDATE_COUNT
  end
end

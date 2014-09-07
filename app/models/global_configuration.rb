class GlobalConfiguration < ActiveRecord::Base

  attr_accessible :votes_given, :votes_accepted, :potential_voters_count

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
    Vaalit::Public::EMAIL_FROM_ADDRESS
  end

  def self.mail_from_name
    Vaalit::Public::EMAIL_FROM_NAME
  end

  def self.votes_given
    first.votes_given
  end

  def self.votes_accepted
    first.votes_accepted
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

  def self.checking_minutes_username
    return first.checking_minutes_username
  end

  def self.checking_minutes_password
    return first.checking_minutes_password
  end

  def candidate_nomination_period_effective?
    Time.now < candidate_nomination_ends_at
  end

  def elected_candidate_count
    Vaalit::Voting::ELECTED_CANDIDATE_COUNT
  end

  def enable_advocate_login!
    self.update_attribute(:advocate_login_enabled, true)
  end

  def disable_advocate_login!
    self.update_attribute(:advocate_login_enabled, false)
  end

end

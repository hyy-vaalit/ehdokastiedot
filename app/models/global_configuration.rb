#
# TODO: Read configuration from environment vars
#
class GlobalConfiguration < ActiveRecord::Base
  def self.candidate_nomination_period_effective?
    Time.now < Vaalit::Config::CANDIDATE_NOMINATION_ENDS_AT
  end

  def self.candidate_nomination_ends_at
    Vaalit::Config::CANDIDATE_NOMINATION_ENDS_AT
  end

  def self.candidate_data_is_freezed_at
    Vaalit::Config::CANDIDATES_FROZEN_AT
  end

  def self.candidate_data_frozen?
    Time.now > candidate_data_is_freezed_at
  end

  def self.mail_from_address
    Vaalit::Public::EMAIL_FROM_ADDRESS
  end

  def self.mail_from_name
    Vaalit::Public::EMAIL_FROM_NAME
  end

  def self.log_candidate_attribute_changes?
    not candidate_nomination_period_effective?
  end

  def self.advocate_login_enabled?
    return first.advocate_login_enabled?
  end

  def enable_advocate_login!
    self.update_attribute(:advocate_login_enabled, true)
  end

  def disable_advocate_login!
    self.update_attribute(:advocate_login_enabled, false)
  end

end

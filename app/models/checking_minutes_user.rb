class CheckingMinutesUser

  # This is a poorly designed authentication for Tarkastuslaskennan pj.
  # Due to Legacy Reasons these were previously stored in Redis.
  # In order to get rid of Redis, the implementation logic was not changed,
  #  only the settings were moved to GlobalConfiguration.
  def self.authenticate(username, password)
    username == GlobalConfiguration.checking_minutes_username && password == GlobalConfiguration.checking_minutes_password
  end
end

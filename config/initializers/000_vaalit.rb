module Vaalit

  module Public
    SITE_ADDRESS        = ENV.fetch 'SITE_ADDRESS'
    ADVOCATE_LOGIN_URL  = "#{SITE_ADDRESS}"
    SECRETARY_LOGIN_URL = "#{SITE_ADDRESS}/admin"
    EMAIL_FROM_ADDRESS  = ENV.fetch 'EMAIL_FROM_ADDRESS'
    EMAIL_FROM_NAME     = ENV.fetch 'EMAIL_FROM_NAME'
  end

  module Config
    CANDIDATE_NOMINATION_ENDS_AT = Time.parse ENV.fetch('CANDIDATE_NOMINATION_ENDS_AT')
    CANDIDATE_DATA_IS_FREEZED_AT = Time.parse ENV.fetch('CANDIDATE_DATA_IS_FREEZED_AT')
    CHECKING_MINUTES_ENABLED     = !!(ENV.fetch('CHECKING_MINUTES_ENABLED') =~ /true/)
  end

  module Voting
    PROPORTIONAL_PRECISION = 5   # Decimals used in proportional numbers (eg. 87.12345 is 5 decimals)
    ELECTED_CANDIDATE_COUNT = 60 # How many candidates are elected
    CALCULATION_BEGINS_AT   = Time.parse ENV.fetch('VOTING_CALCULATION_BEGINS_AT')
  end

  module Results
    RESULT_ADDRESS  = ENV.fetch 'RESULT_ADDRESS'
    DIRECTORY       = Time.now.year
    PUBLIC_RESULT_URL = "#{RESULT_ADDRESS}/#{DIRECTORY}"
  end

  module Aws
    module Ses
      REGION = ENV.fetch('AWS_SES_REGION', "eu-central-1")
      ACCESS_KEY_ID = ENV.fetch('AWS_SES_ACCESS_KEY_ID')
      SECRET_ACCESS_KEY = ENV.fetch('AWS_SES_SECRET_ACCESS_KEY')
    end

    def self.connect?
      Rails.env.production?
    end
  end
end

module Vaalit

  module Public
    SITE_ADDRESS        = "https://vaalit.hyy.fi"
    ADVOCATE_LOGIN_URL  = "#{SITE_ADDRESS}"
    SECRETARY_LOGIN_URL = "#{SITE_ADDRESS}/admin"
    EMAIL_FROM_ADDRESS  = "vaalit@hyy.fi"
    EMAIL_FROM_NAME     = "Silva Loikkanen"
  end

  module Config
    CANDIDATE_NOMINATION_ENDS_AT = Time.parse ENV.fetch('CANDIDATE_NOMINATION_ENDS_AT')
    CANDIDATE_DATA_IS_FREEZED_AT = Time.parse ENV.fetch('CANDIDATE_DATA_IS_FREEZED_AT')
    CHECKING_MINUTES_ENABLED     = !!(ENV.fetch('CHECKING_MINUTES_ENABLED') =~ /true/)
  end

  module Voting
    PROPORTIONAL_PRECISION = 5   # Decimals used in proportional numbers (eg. 87.12345 is 5 decimals)
    ELECTED_CANDIDATE_COUNT = 60 # How many candidates are elected

    if (ENV['VOTING_CALCULATION_BEGINS_AT'])
      CALCULATION_BEGINS_AT = Time.parse(ENV['VOTING_CALCULATION_BEGINS_AT'])
    else
      raise "Set ENV['VOTING_CALCULATION_BEGINS_AT'] in .env"
    end

  end

  module Results
    S3_BUCKET_NAME  = ENV['S3_BUCKET_NAME'] || "hyy-koe"
    S3_BASE_URL     = ENV['S3_BASE_URL'] || "s3.amazonaws.com"

    RESULT_ADDRESS  = ENV['RESULT_ADDRESS'] || "http://hyy-koe.s3-website-us-east-1.amazonaws.com"
    DIRECTORY       = Time.now.year
    PUBLIC_RESULT_URL = "#{RESULT_ADDRESS}/#{DIRECTORY}"

  end

  module AWS
    def self.connect?
      Rails.env.production?
    end

    if connect?
      ::AWS::S3::Base.establish_connection!(
        :access_key_id     => ENV['S3_ACCESS_KEY_ID'],
        :secret_access_key => ENV['S3_ACCESS_KEY_SECRET']
      )
    end
  end

end

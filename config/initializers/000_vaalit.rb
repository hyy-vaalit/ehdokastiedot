module Vaalit

  module Public
    SITE_ADDRESS        = "http://vaalit.hyy.fi"
    ADVOCATE_LOGIN_URL  = "#{SITE_ADDRESS}"
    SECRETARY_LOGIN_URL = "#{SITE_ADDRESS}/admin"
    EMAIL_FROM_ADDRESS  = "vaalit@hyy.fi"
    EMAIL_FROM_NAME     = "Emma Ronkainen"
  end

  module Voting
    PROPORTIONAL_PRECISION = 5   # Decimals used in proportional numbers (eg. 87.12345 is 5 decimals)
    ELECTED_CANDIDATE_COUNT = 60 # How many candidates are elected
  end

  module Results
    S3_BUCKET_NAME  = ENV['S3_BUCKET_NAME'] || "hyy-koe"
    S3_BASE_URL     = ENV['S3_BASE_URL'] || "s3.amazonaws.com"
    S3_BUCKET_URL   = "http://#{S3_BASE_URL}/#{S3_BUCKET_NAME}"

    RESULT_ADDRESS  = ENV['RESULT_ADDRESS'] || "http://vaalitulos.hyy.fi"
    PUBLIC_FILENAME = "tulos.txt"
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
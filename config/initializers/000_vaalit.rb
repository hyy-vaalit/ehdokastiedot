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
    PUBLIC_FILENAME = "tulos-alustava.txt"
    DIRECTORY       = Time.now.year
    S3_BUCKET_URL   = "http://#{S3_BASE_URL}/#{S3_BUCKET_NAME}"
    S3_RESULT_PATH  = "#{S3_BUCKET_URL}/#{DIRECTORY}"
    PUBLIC_RESULT_URL = "#{S3_RESULT_PATH}/#{PUBLIC_FILENAME}"
  end
end
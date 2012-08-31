module Vaalit

  module Public
    SITE_ADDRESS        = "http://vaalit.hyy.fi"
    ADVOCATE_LOGIN_URL  = "#{SITE_ADDRESS}"
    SECRETARY_LOGIN_URL = "#{SITE_ADDRESS}/admin"
    DEVISE_SENDER_EMAIL = "petrus.repo+vaalit@gmail.com"
  end

  module Voting
    PROPORTIONAL_PRECISION = 5   # Decimals used in proportional numbers (eg. 87.12345 is 5 decimals)
    ELECTED_CANDIDATE_COUNT = 60 # How many candidates are elected
  end

  module Results
    S3_BUCKET_NAME  = ENV['S3_BUCKET_NAME'] || "hyy-vaalitulos-staging"
    S3_BASE_URL     = ENV['S3_BASE_URL'] || "s3.amazonaws.com"
    PUBLIC_FILENAME = "tulos-alustava.txt"
    S3_BUCKET_URL   = "http://#{S3_BASE_URL}/#{S3_BUCKET_NAME}"

    PUBLIC_RESULT_URL = "#{Vaalit::Results::S3_BUCKET_URL}/#{Vaalit::Results::PUBLIC_FILENAME}"
  end
end
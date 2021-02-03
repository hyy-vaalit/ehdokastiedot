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
    CANDIDATES_FROZEN_AT = Time.parse ENV.fetch('CANDIDATES_FROZEN_AT')
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

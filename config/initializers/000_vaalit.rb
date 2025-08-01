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
    CANDIDATE_NOMINATION_STARTS_AT = Time.parse ENV.fetch('CANDIDATE_NOMINATION_STARTS_AT')
    CANDIDATES_FROZEN_AT = Time.parse ENV.fetch('CANDIDATES_FROZEN_AT')

    HTTP_BASIC_AUTH_USERNAME = ENV.fetch('HTTP_BASIC_AUTH_USERNAME', nil)
    HTTP_BASIC_AUTH_PASSWORD = ENV.fetch('HTTP_BASIC_AUTH_PASSWORD', nil)

    def self.http_basic_auth?
      !Vaalit::Config::HTTP_BASIC_AUTH_USERNAME.blank?
    end

    def self.fake_auth_enabled?
      Rails.env.development? && (ENV.fetch("FAKE_AUTH_ENABLED", "no") == "yes")
    end
  end

  module Haka
    SAML_NAME_IDENTIFIER_FORMAT = ENV.fetch('SAML_NAME_IDENTIFIER_FORMAT')
    SAML_IDP_SSO_TARGET_URL = ENV.fetch("SAML_IDP_SSO_TARGET_URL")
    SAML_IDP_ENTITY_ID = ENV.fetch("SAML_IDP_ENTITY_ID")
    SAML_IDP_CERT_FINGERPRINT = ENV.fetch("SAML_IDP_CERT_FINGERPRINT", "")
    SAML_IDP_CERT = ENV.fetch("SAML_IDP_CERT")

    SAML_ASSERTION_CONSUMER_SERVICE_URL = ENV.fetch("SAML_ASSERTION_CONSUMER_SERVICE_URL")

    SAML_MY_ENTITY_ID = ENV.fetch("SAML_MY_ENTITY_ID")
    SAML_MY_CERT = ENV.fetch("SAML_MY_CERT")
    SAML_MY_PRIVATE_KEY = ENV.fetch("SAML_MY_PRIVATE_KEY")

    HAKA_STUDENT_NUMBER_FIELD = ENV.fetch("HAKA_STUDENT_NUMBER_FIELD")
    HAKA_STUDENT_NUMBER_KEY = ENV.fetch("HAKA_STUDENT_NUMBER_KEY")
    HAKA_EMAIL_FIELD = ENV.fetch("HAKA_EMAIL_FIELD")
    HAKA_CN_FIELD = ENV.fetch("HAKA_CN_FIELD")
    HAKA_SN_FIELD = ENV.fetch("HAKA_SN_FIELD")
    HAKA_GIVENNAME_FIELD = ENV.fetch("HAKA_GIVENNAME_FIELD")
    HAKA_HOMEORG_FIELD = ENV.fetch("HAKA_HOMEORG_FIELD")
  end

  module Aws
    def self.connect?
      Rails.env.production?
    end
  end
end

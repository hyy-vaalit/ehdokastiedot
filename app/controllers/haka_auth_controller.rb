class HakaAuthController < ApplicationController
  # Authentication is always available, but access may be denied at the resource later.
  skip_authorization_check

  # SAML consume endpoint is not compatible with CSRF protection, but SAML has a mechanism of
  # its own to protect against CSRF.
  protect_from_forgery except: [:consume], with: :exception

  # /haka/auth/fake_authentication
  def new_fake_authentication; end

  def create_fake_authentication
    raise NotImplementedError, "Fake authentication is not enabled" unless Vaalit::Config.fake_auth_enabled?

    session[:haka_attrs] = {
      "student_number" => params[:fake_authentication][:student_number]
    }

    redirect_to registrations_root_path
  end

  # Initiates a new SAML sign in request
  def new
    if current_haka_user
      flash.notice = "Olet jo kirjautunut sisään."
      redirect_to registrations_root_path and return
    end

    request = OneLogin::RubySaml::Authrequest.new
    redirect_to(request.create(saml_settings))
  end

  # Receives the SAML assertion after Haka sign in
  def consume
    response = OneLogin::RubySaml::Response.new(
      params[:SAMLResponse],
      settings: saml_settings,
      allowed_clock_drift: 5.seconds
    )

    unless response.is_valid?
      Rails.logger.error "Invalid SAML response: #{response.errors}"
      Rollbar.error "Invalid SAML response", errors: response.errors

      flash.alert = "Sisäänkirjautumisessa tapahtui odottamaton virhe. Yritä uudelleen."
      redirect_to root_path and return
    end

    Rails.logger.debug "Reponse attributes: #{response.attributes.inspect}"
    session[:haka_attrs] = {
      "student_number" => response.attributes[Vaalit::Haka::HAKA_STUDENT_NUMBER_FIELD],
      "email" => response.attributes[Vaalit::Haka::HAKA_EMAIL_FIELD],
      "fullname" => response.attributes[Vaalit::Haka::HAKA_CN_FIELD],
      "firstname" => response.attributes[Vaalit::Haka::HAKA_GIVENNAME_FIELD],
      "lastname" => response.attributes[Vaalit::Haka::HAKA_SN_FIELD],
      "homeorg" => response.attributes[Vaalit::Haka::HAKA_HOMEORG_FIELD]
    }

    haka_user = HakaUser.new(attrs: session[:haka_attrs])
    if haka_user.advocate_user
      haka_user.advocate_user.tap do |a|
        a.last_sign_in_at = a.current_sign_in_at
        a.current_sign_in_at = Time.now.getutc
        a.save!
      end
    end

    redirect_to registrations_root_path
  end

  # https://api.rubyonrails.org/classes/ActionController/Base.html > Sessions
  def destroy
    reset_session

    flash.notice = "Olet kirjautunut ulos."
    redirect_to root_path
  end

  private

  def saml_settings
    settings = OneLogin::RubySaml::Settings.new

    # Require identity provider to (re)authenticate user also when a
    # previously authenticated session is still valid.
    settings.force_authn = true

    settings.idp_entity_id = Vaalit::Haka::SAML_IDP_ENTITY_ID
    settings.idp_sso_target_url = Vaalit::Haka::SAML_IDP_SSO_TARGET_URL
    settings.idp_cert = Vaalit::Haka::SAML_IDP_CERT

    settings.assertion_consumer_service_url = Vaalit::Haka::SAML_ASSERTION_CONSUMER_SERVICE_URL
    settings.name_identifier_format = Vaalit::Haka::SAML_NAME_IDENTIFIER_FORMAT

    settings.sp_entity_id = Vaalit::Haka::SAML_MY_ENTITY_ID
    settings.certificate = Vaalit::Haka::SAML_MY_CERT
    settings.private_key = Vaalit::Haka::SAML_MY_PRIVATE_KEY

    # Fingerprint can be used in local testing instead of a cert.
    # When SAML assertions are encrypted, an actual cert is required and
    # fingerprint can be left blank.
    if Vaalit::Haka::SAML_IDP_CERT_FINGERPRINT.present?
      settings.idp_cert_fingerprint         = Vaalit::Haka::SAML_IDP_CERT_FINGERPRINT
    end

    settings
  end
end

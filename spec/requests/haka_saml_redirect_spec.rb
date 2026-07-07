require 'spec_helper'

describe "Haka SAML sign-in" do
  # raise_on_open_redirects (Rails 7.0+ defaults) blocks redirects to other
  # hosts; the identity provider redirect must explicitly allow it.
  it "redirects to the external identity provider" do
    idp_url = "#{Vaalit::Haka::SAML_IDP_SSO_TARGET_URL}?SAMLRequest=dummy"
    allow_any_instance_of(OneLogin::RubySaml::Authrequest)
      .to receive(:create).and_return(idp_url)

    get haka_auth_new_path

    expect(response).to have_http_status(:redirect)
    expect(response.location).to eq idp_url
  end
end

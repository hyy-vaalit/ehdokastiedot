require 'spec_helper'

# Regression specs for session fixation: an attacker who plants a session
# cookie before the victim logs in must not inherit the authenticated session.
describe HakaAuthController, type: :controller do
  describe "#create_fake_authentication" do
    it "resets the pre-login session" do
      session[:planted_by_attacker] = "anything"

      post :create_fake_authentication,
        params: { fake_authentication: { student_number: "012345678" } }

      expect(session[:planted_by_attacker]).to be_nil
      expect(session[:haka_attrs]).to be_present
      expect(response).to redirect_to(registrations_root_path)
    end
  end

  describe "#consume" do
    it "resets the pre-login session" do
      student_number_urn = "#{Vaalit::Haka::HAKA_STUDENT_NUMBER_KEY}:012345678"
      attributes = double("Attributes", multi: [student_number_urn], single: "value")
      saml_response = double("Response", is_valid?: true, attributes: attributes)
      allow(OneLogin::RubySaml::Response).to receive(:new).and_return(saml_response)

      session[:planted_by_attacker] = "anything"

      post :consume, params: { SAMLResponse: "dummy" }

      expect(session[:planted_by_attacker]).to be_nil
      expect(session[:haka_attrs]).to be_present
      expect(response).to redirect_to(registrations_root_path)
    end
  end
end

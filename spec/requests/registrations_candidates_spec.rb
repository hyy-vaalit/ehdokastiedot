require 'spec_helper'

describe "Candidate registration" do
  let(:student_number) { "012345678" }

  before { sign_in_haka student_number }

  describe "after the candidacy has been cancelled" do
    before do
      create(:candidate, student_number: student_number).cancel
    end

    it "cancelling again redirects instead of crashing" do
      post cancel_registrations_candidate_path

      expect(response).to redirect_to(registrations_candidate_path)
      expect(flash[:alert]).to be_present
    end

    it "resubmitting the edit form redirects instead of crashing" do
      patch registrations_candidate_path,
        params: { candidate: { phone_number: "040123" } }

      expect(response).to redirect_to(registrations_candidate_path)
      expect(flash[:alert]).to be_present
    end
  end

  describe "creating with a stale invite code" do
    it "redirects to the registration front page instead of crashing" do
      post registrations_candidate_path, params: {
        invite_code: "EIOO",
        candidate: {
          lastname: "Meikäläinen",
          firstname: "Matti",
          candidate_name: "Meikäläinen, Matti",
          email: "matti@example.com"
        }
      }

      expect(response).to redirect_to(registrations_root_path)
      expect(flash[:alert]).to include("ei ole voimassa")
      expect(Candidate.count).to eq 0
    end
  end

  describe "creating with a valid invite code" do
    it "creates the candidate" do
      alliance = create(:electoral_alliance, invite_code: "KOODI")

      post registrations_candidate_path, params: {
        invite_code: "koodi",
        candidate: {
          lastname: "Meikäläinen",
          firstname: "Matti",
          candidate_name: "Meikäläinen, Matti",
          email: "matti@example.com"
        }
      }

      expect(response).to redirect_to(registrations_candidate_path(student_number))
      expect(alliance.candidates.count).to eq 1
    end
  end
end

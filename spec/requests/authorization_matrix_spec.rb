require 'spec_helper'

# Authorization boundaries per role. The manage-page and admin boundaries
# are covered in spec/requests/manage_pages_spec.rb, team alliance access
# in spec/requests/advocates_alliances_spec.rb.
describe "Authorization boundaries" do
  describe "guest" do
    it "gets 401 from registration pages" do
      get registrations_root_path
      expect(response).to have_http_status(:unauthorized)

      get registrations_candidate_path
      expect(response).to have_http_status(:unauthorized)
    end

    it "is redirected away from advocate pages" do
      get advocates_alliances_path
      expect(response).to redirect_to(registrations_root_path)
    end
  end

  describe "Haka user without advocate rights" do
    before { sign_in_haka "012345678" }

    it "is redirected away from advocate pages" do
      get advocates_alliances_path
      expect(response).to redirect_to(registrations_root_path)
    end
  end

  describe "Haka user outside the nomination period" do
    let(:student_number) { "012345678" }

    before { sign_in_haka student_number }

    it "cannot register as a candidate during the correction period" do
      allow(GlobalConfiguration).to receive(:candidate_nomination_period_effective?).and_return(false)
      allow(GlobalConfiguration).to receive(:candidate_data_correction_period?).and_return(true)
      allow(GlobalConfiguration).to receive(:candidate_data_frozen?).and_return(false)

      get new_registrations_candidate_path, params: { invite_code: "ABCD" }

      expect(response).to have_http_status(:forbidden)
    end

    it "can still update but not create during the correction period" do
      candidate = create(:candidate, student_number: student_number)

      allow(GlobalConfiguration).to receive(:candidate_nomination_period_effective?).and_return(false)
      allow(GlobalConfiguration).to receive(:candidate_data_correction_period?).and_return(true)
      allow(GlobalConfiguration).to receive(:candidate_data_frozen?).and_return(false)
      allow(GlobalConfiguration).to receive(:log_candidate_attribute_changes?).and_return(false)

      patch registrations_candidate_path, params: { candidate: { phone_number: "040111" } }

      expect(response).to redirect_to(registrations_candidate_path)
      expect(candidate.reload.phone_number).to eq "040111"
    end

    it "cannot update or cancel when candidate data is frozen" do
      candidate = create(:candidate, student_number: student_number, phone_number: "unchanged")

      allow(GlobalConfiguration).to receive(:candidate_nomination_period_effective?).and_return(false)
      allow(GlobalConfiguration).to receive(:candidate_data_correction_period?).and_return(false)
      allow(GlobalConfiguration).to receive(:candidate_data_frozen?).and_return(true)

      patch registrations_candidate_path, params: { candidate: { phone_number: "040999" } }
      expect(response).to have_http_status(:forbidden)

      post cancel_registrations_candidate_path
      expect(response).to have_http_status(:forbidden)

      expect(candidate.reload.phone_number).to eq "unchanged"
      expect(candidate.cancelled).to eq false
    end
  end

  describe "advocate when advocate login is disabled" do
    it "is denied" do
      create(:global_configuration, advocate_login_enabled: false)
      advocate = create(:advocate_user)
      sign_in_haka advocate.student_number

      get advocates_alliances_path

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "advocate and a foreign alliance's candidates" do
    let(:advocate) { create(:advocate_user) }
    let(:foreign_alliance) { create(:electoral_alliance) }

    before do
      create(:global_configuration)
      sign_in_haka advocate.student_number
    end

    it "cannot create a candidate into a foreign alliance" do
      expect {
        post advocates_alliance_candidates_path(foreign_alliance), params: {
          candidate: {
            lastname: "Vieras", firstname: "Ville",
            candidate_name: "Vieras, Ville",
            email: "ville@example.com", student_number: "999888"
          }
        }
      }.not_to change { Candidate.count }

      expect(response).to have_http_status(:redirect)
    end

    it "cannot update a foreign alliance's candidate" do
      candidate = create(:candidate, electoral_alliance: foreign_alliance, phone_number: "unchanged")

      patch advocates_alliance_candidate_path(foreign_alliance, candidate),
        params: { candidate: { phone_number: "040999" } }

      expect(response).to have_http_status(:redirect)
      expect(candidate.reload.phone_number).to eq "unchanged"
    end
  end
end

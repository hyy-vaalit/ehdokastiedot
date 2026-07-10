require 'spec_helper'

describe "Happy paths" do
  describe "candidate registration flow" do
    it "shows the form with a valid invite code" do
      alliance = create(:electoral_alliance, invite_code: "KOODI")
      sign_in_haka "012345678"

      get new_registrations_candidate_path, params: { invite_code: "koodi" }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(alliance.name)
    end
  end

  describe "admin candidate management" do
    it "renders the candidate edit form" do
      candidate = create(:candidate)
      sign_in create(:admin_user)

      get edit_admin_candidate_path(candidate)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(candidate.electoral_alliance.name)
    end
  end

  describe "advocate alliance and candidate management" do
    let(:advocate) { create(:advocate_user) }

    before do
      create(:global_configuration)
      sign_in_haka advocate.student_number
    end

    it "creates an alliance owned by the advocate" do
      post advocates_alliances_path, params: {
        electoral_alliance: {
          name: "Uusi vaaliliitto",
          shorten: "UUSI",
          expected_candidate_count: 5,
          invite_code: "UU-12"
        }
      }

      alliance = ElectoralAlliance.find_by(name: "Uusi vaaliliitto")
      expect(alliance).to be_present
      expect(alliance.advocate_user).to eq advocate
      expect(response).to redirect_to(advocates_alliance_path(alliance))
    end

    # Note: the ability grants :create, Candidate only for one's own student
    # number — candidates register themselves; advocates edit, not create.
    it "edits a candidate in the advocate's own alliance" do
      alliance = create(:electoral_alliance, advocate_user: advocate)
      candidate = create(:candidate, electoral_alliance: alliance)

      patch advocates_alliance_candidate_path(alliance, candidate),
        params: { candidate: { phone_number: "040 123" } }

      expect(response).to redirect_to(advocates_alliance_path(alliance))
      expect(candidate.reload.phone_number).to eq "040 123"
    end
  end

  describe "admin CSV exports" do
    before do
      coalition = create(:electoral_coalition)
      alliance = create(:electoral_alliance, electoral_coalition: coalition)
      create_list(:candidate, 3, electoral_alliance: alliance)
      sign_in create(:admin_user)
    end

    def parse_csv(body, encoding)
      CSV.parse(body.dup.force_encoding(encoding).encode("UTF-8"))
    end

    it "exports candidates, alliances and coalitions in both encodings" do
      {
        manage_candidates_path(format: :csv) => 4, # header + 3 candidates
        reduced_manage_candidates_path(format: :csv) => 4,
        manage_electoral_alliances_path(format: :csv) => 2,
        manage_electoral_coalitions_path(format: :csv) => 2
      }.each do |path, expected_rows|
        get path
        expect(response).to have_http_status(:ok)
        rows = parse_csv(response.body, "UTF-8")
        expect(rows.length).to eq(expected_rows), "#{path}: expected #{expected_rows} rows, got #{rows.length}"
      end

      [
        manage_candidates_path(format: :csv, isolatin: true),
        manage_electoral_alliances_path(format: :csv, isolatin: true),
        manage_electoral_coalitions_path(format: :csv, isolatin: true)
      ].each do |path|
        get path
        expect(response).to have_http_status(:ok)
        expect { parse_csv(response.body, "ISO-8859-1") }.not_to raise_error
      end
    end
  end

  describe "candidate numbering end to end" do
    it "assigns numbers through the danger zone" do
      coalition = create(:electoral_coalition)
      2.times do
        alliance = create(:electoral_alliance, electoral_coalition: coalition)
        create_list(:candidate, 2, electoral_alliance: alliance)
      end
      sign_in create(:admin_user)

      post give_candidate_numbers_manage_danger_zone_path

      expect(response).to redirect_to(manage_candidates_path)
      expect(Candidate.valid.pluck(:candidate_number).sort).to eq [2, 3, 4, 5]
    end
  end
end

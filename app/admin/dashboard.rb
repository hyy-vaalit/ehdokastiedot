# Reference:
# https://github.com/activeadmin/activeadmin/blob/master/lib/generators/active_admin/install/templates/dashboard.rb
#
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    columns do
      column max_width: "300px" do
        panel "Ylläpidon toiminnot" do
          section 'Ehdokastiedot' do
            ul do
              li link_to 'Yksinkertaistettu lista ehdokastiedoista', simple_listings_path
              li link_to 'Edustajien muutokset ehdokasasettelun päättymisen jälkeen', manage_candidate_attribute_changes_path
            end
          end

          # Please note that in order to have control over the CSV export, you must use a custom controller.
          # See eg. manage/candidates_controller for Candidate CSV export.
          section "Tiedot Exceliin (CSV Export)" do
            ul do
              li link_to "Ehdokkaat (UTF-8)", manage_candidates_path(:format=>:csv)
              li link_to "Ehdokkaat (ISO-Latin)", manage_candidates_path(:format=>:csv, :isolatin=>true)
              li link_to "Vaaliliitot (UTF-8)", manage_electoral_alliances_path(:format=>:csv)
              li link_to "Vaaliliitot (ISO-Latin)", manage_electoral_alliances_path(:format=>:csv, :isolatin=>true)
              li link_to "Vaalirenkaat (UTF-8)", manage_electoral_coalitions_path(:format=>:csv)
              li link_to "Vaalirenkaat (ISO-Latin)", manage_electoral_coalitions_path(:format=>:csv, :isolatin=>true)
            end
            section "Ohjeet CSV-tiedoston tuomiseksi Exceliin" do
              ol do
                li "Avaa CSV-tiedosto Exceliin."
                li "Valitse ja mustaa koko sarake 'A'."
                li "Valitse: Tiedot > Teksti sarakkeisiin"
                li "Valitse: Tiedostolaji: Erotettu > Seuraava."
                li "Valitse: Erottimet: Pilkku > Valmis."
                li "HUOM! Google Docsille UTF-8, MS Excelille ISO-Latin."
              end
            end
          end

           section 'X-files', :priority => 999 do
            ul do
              li link_to 'Vaaralliset toiminnot', manage_danger_zone_path
              li link_to 'Sähköpostien lähetystiedot', "#TODO"
            end
          end

          section 'Muiden sidosryhmien sisäänkirjautuminen' do
            ul do
              li link_to 'Edustaja (liiton 1. edustaja)', advocate_index_path
            end
          end
        end
      end # column toiminnot

      column span: 2 do
        panel "Vaaliliitot" do
          ul do
            if GlobalConfiguration.advocate_login_enabled?
              li "Edustajat voivat kirjautua sisään: Kytke kirjautuminen pois aina ennen Keskusvaalilautakunnan kokousta, jotta ehdokastiedot tai -numerot eivät vuoda julkisiksi liian aikaisin."
            else
              li "Edustajat EIVÄT VOI kirjautua sisään: Kytke kirjautuminen päälle, kun haluat että edustajat saavat ehdokastietonsa ja -numeronsa."
            end
            li "Edustajat voivat luoda uusia ehdokkaita ja vaaliliittoja ehdokasasettelun päättymiseen saakka
               (#{friendly_datetime(GlobalConfiguration.candidate_nomination_ends_at)})."
            li "Edustajat voivat tehdä ehdokastietoihin korjauksia tietojen jäädyttämiseen saakka
               (#{friendly_datetime(GlobalConfiguration.candidate_data_is_freezed_at)})."
            li "Edustajat voivat lukea ja ladata oman vaaliliittonsa ehdokastiedot vielä jäädyttämisenkin jälkeen."
            li "Vaaliliiton edustajien sisäänkirjautuminen kannattaa varmuussyistä estää viimeistään vaalipäivänä ennen ääntenlaskun alkamista (vaarallisten toimintojen sivulta)."
          end

          table_for(ElectoralAlliance.for_dashboard) do |t|
            t.column("Valmis") { |alliance| status_tag('Valmis', class: 'ok') if alliance.secretarial_freeze? }
            t.column("Vaaliliitto") { |alliance| link_to alliance.name, admin_electoral_alliance_path(alliance) }
            t.column("Ehdokkaita syötetty") {|alliance| alliance.candidates.count}
            t.column("Ehdokkaita odotetaan") {|alliance| alliance.expected_candidate_count}
            t.column("Kaikki syötetty") {|alliance| alliance.has_all_candidates? ? status_tag('ok', class: 'ok') : status_tag("Kesken", class: 'in_progress') }
            t.column("Edustaja") {|alliance| link_to alliance.advocate_user.friendly_name, admin_advocate_user_path(alliance.advocate_user) if alliance.advocate_user}
          end
        end
      end # column vaaliliitot
    end # columns
  end # content
end

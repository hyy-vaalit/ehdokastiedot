# coding: utf-8

ActiveAdmin::Dashboards.build do

  section "Vaaliliitot" do
    ul do
      if GlobalConfiguration.advocate_login_enabled?
        li "Asiamiehet voivat kirjautua sisään: Kytke kirjautuminen pois aina ennen Keskusvaalilautakunnan kokousta, jotta ehdokastiedot tai -numerot eivät vuoda julkisiksi liian aikaisin."
      else
        li "Asiamiehet EIVÄT VOI kirjautua sisään: Kytke kirjautuminen päälle, kun haluat että asiamiehet saavat ehdokastietonsa ja -numeronsa."
      end
      li "Asiamiehet voivat luoda uusia ehdokkaita ja vaaliliittoja ehdokasasettelun päättymiseen saakka
         (#{friendly_datetime(GlobalConfiguration.candidate_nomination_ends_at)})."
      li "Asiamiehet voivat tehdä ehdokastietoihin korjauksia tietojen jäädyttämiseen saakka
         (#{friendly_datetime(GlobalConfiguration.candidate_data_is_freezed_at)})."
      li "Asiamiehet voivat lukea ja ladata oman vaaliliittonsa ehdokastiedot vielä jäädyttämisenkin jälkeen."
      li "Asiamiesten sisäänkirjautuminen kannattaa varmuussyistä estää viimeistään vaalipäivänä ennen ääntenlaskun alkamista (vaarallisten toimintojen sivulta)."
    end

    table_for(ElectoralAlliance.for_dashboard) do |t|
      t.column("Valmis") { |alliance| icon(:check) if alliance.secretarial_freeze? }
      t.column("Vaaliliitto") { |alliance| link_to alliance.name, admin_electoral_alliance_path(alliance) }
      t.column("Ehdokkaita syötetty") {|alliance| alliance.candidates.count}
      t.column("Ehdokkaita ilmoitettu") {|alliance| alliance.expected_candidate_count}
      t.column("Kaikki syötetty") {|alliance| alliance.has_all_candidates? ? icon(:check) : ""}
      t.column("Asiamies") {|alliance| link_to alliance.advocate_user.friendly_name, admin_advocate_user_path(alliance.advocate_user) if alliance.advocate_user}
    end
  end

  section "Ylläpidon toiminnot", :priority => 2 do
    section 'Ehdokastiedot' do
      ul do
        li link_to 'Yksinkertaistettu lista ehdokastiedoista', simple_listings_path
        li link_to 'Ehdokkaat, joilla sama henkilöturvatunnus', same_ssn_listings_path
        li link_to 'Asiamiesten muutokset ehdokasasettelun päättymisen jälkeen', manage_candidate_attribute_changes_path
      end
    end

    section "Tiedot Exceliin (CSV Export)" do
      ul do
        li link_to "Kaikki ehdokkaat (csv)", manage_candidates_path(:format=>:csv)
        li link_to "Kaikki vaaliliitot (csv)", admin_electoral_alliances_path(:format=>:csv)
        li link_to "Kaikki vaalirenkaat (csv)", admin_electoral_coalitions_path(:format=>:csv)
      end
      section "Ohjeet CSV-tiedoston tuomiseksi Exceliin" do
        ol do
          li "Avaa CSV-tiedosto Exceliin."
          li "Valitse ja mustaa koko sarake 'A'."
          li "Valitse: Tiedot > Teksti sarakkeisiin"
          li "Valitse: Tiedostolaji: Erotettu > Seuraava."
          li "Valitse: Erottimet: Pilkku > Valmis."
        end
      end
    end

    section 'Vaalivalvojaiset' do
      ul do
        li link_to 'Äänestysalueet ääntenlaskentaan', showdown_listings_path
        li link_to 'Vaalitulokset', manage_results_path
      end
    end

    section 'Tarkastuslaskenta' do
      ul do
        li link_to 'Korjauspöytäkirjat', checking_minutes_path
        li link_to 'Yhteenveto', summary_checking_minutes_path
      end
    end

    section 'Vaalituloksen vahvistaminen' do
      ul do
        li link_to 'Arvonnat', draws_path
        li link_to 'Lopullinen vaalitulos', manage_results_path
      end
    end

    section 'X-files', :priority => 999 do
      ul do
        li link_to 'Järjestelmän asetukset', edit_manage_configuration_path
        li link_to 'Sähköpostien lähetystiedot', "http://sendgrid.com/"
        li link_to 'Vaaralliset toiminnot', manage_danger_zone_path
      end
    end

    section 'Muiden sidosryhmien sisäänkirjautuminen' do
      ul do
        li link_to 'Asiamies (liiton 1. asiamies)', advocate_index_path
        li link_to 'Äänestysalue (äänestysalueen pj)', voting_area_path
        li link_to 'Tarkastuslaskenta (tllk:n pj)', checking_minutes_path
      end
    end

  end


  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end

  # == Render Partial Section
  # The block is rendererd within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #   end

  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.

end

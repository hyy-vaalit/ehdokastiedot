# coding: utf-8
ActiveAdmin::Dashboards.build do

  # section "Sihteerin toiminnot", :priority => 1 do
  #   h3 do
  #     ol do
  #       li link_to "Luo uusi vaaliliitto.", new_admin_electoral_alliance_path
  #       li "Luo ehdokkaat valitsemalla #{link_to 'luomasi vaaliliiton sivun', admin_electoral_alliances_path}<br />
  #           oikeasta yläkulmasta 'Vaaliliiton ehdokkaat'.".html_safe
  #       li "Syötä ehdokkaat samassa järjestyksessä kuin haluat ehdokasnumerot."
  #       li "Kun ehdokkaat on syötetty,<br />
  #           klikkaa em. valikosta 'Merkitse vaaliliitto valmiiksi'.".html_safe
  # p "Kun olet syöttänyt kaikki vaaliliiton ehdokkaat,
  #      #{link_to 'siirry vaaliliiton sivuille', admin_electoral_alliances_path}
  #     ja merkitse vaaliliitto valmiiksi.".html_safe
  #
  #     end
  #   end
  #     h4 "Huomioi nämä:"
  #     ul do
  #       li "Syötä vasta lopulliset tiedot: <br />
  #           tietojen tulee vastata paperisia ehdokaslomakkeita.".html_safe
  #       li "Et voi poistaa syöttämiäsi tietoja etkä muuttaa järjestystä."
  #       li "Virhesyöttöjen välttämiseksi selaimen täydennysehdotuksen<br />
  #           voi valita ainoastaan tabulaattorilla eikä enter-napilla.".html_safe
  #       li "Voit luoda uuden vaaliliiton vasta,<br />
  #           kun edellinen vaaliliitto on merkitty valmiiksi.".html_safe
  #       li "HYYn vaalityöntekijä kytkee vaaliliitot vaalirenkaisiin<br />
  #           ehdokasasettelun päättymisen jälkeen.".html_safe
  #       li "Näet etusivulla linkkejä, joihin et pääse käsiksi.<br />
  #           Pahoittelemme hämmennystä.".html_safe
  #     end
  #
  # end

  alliances = ElectoralAlliance.for_dashboard
  section "Vaaliliitot  (#{alliances.count} kpl)" do
    table_for(alliances) do |t|
      t.column("Valmis") { |alliance| icon(:check) if alliance.secretarial_freeze? }
      t.column("Vaaliliitto") { |alliance| link_to alliance.name, admin_electoral_alliance_path(alliance) }
      t.column("Ehdokkaita syötetty") {|alliance| alliance.candidates.count}
      t.column("Ehdokkaita ilmoitettu") {|alliance| alliance.expected_candidate_count}
      t.column("Kaikki syötetty") {|alliance| alliance.has_all_candidates? ? icon(:check) : ""}
      t.column("Asiamies") {|alliance| link_to alliance.advocate_user.friendly_name, admin_advocate_user_path(alliance.advocate_user) if alliance.advocate_user}
    end
  end

  section "Ylläpidon toiminnot", :priority => 2 do
    section "Tiedot Exceliin (CSV Export)" do
      ul do
        li link_to "Kaikki ehdokkaat (csv)", admin_candidates_path(:format=>:csv)
        li link_to "Peruuttaneet ehdokkaat (csv)", cancelled_emails_admin_candidates_path
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

    section 'Ehdokastiedot' do
      ul do
        li link_to 'Yksinkertaistettu lista ehdokastiedoista', simple_listings_path
        li link_to 'Ehdokkaat, joilla sama henkilöturvatunnus', same_ssn_listings_path
        li link_to 'Asiamiesten korjaukset ehdokastietoihin', has_fixes_listings_path
      end
    end

    section 'Vaalivalvojaiset' do
      ul do
        li link_to 'Äänestysalueet ääntenlaskentaan', showdown_listings_path
        li link_to 'Vaalitulokset', results_path
        # li link_to 'Ehdokkaat läpipääsyn mukaan', deputies_results_path
        # li link_to 'Ehdokkaat vaaliliitoittain', by_alliance_results_path
        # FIXME: ei saa syöttövaiheessa olla julkinen: li link_to 'Ehdokkaat äänimäärän mukaan', by_votes_results_path
      end
    end

    section 'Vaalituloksen vahvistaminen' do
      ul do
        li link_to 'Tarkastuslaskennan korjausyhteenveto', summary_checking_minutes_path
        li link_to 'Arvonnat', draws_path
        li link_to 'Lopullinen vaalitulos', results_path
      end
    end

    section 'X-files', :priority => 999 do
      ul do
        li link_to 'Järjestelmän asetukset', configurations_path
        li link_to 'Vaaralliset toiminnot', tools_path
      end
    end

    section 'Muiden sidosryhmien sisäänkirjautuminen' do
      ul do
        li link_to 'Asiamiesten korjaukset (liiton 1. asiamies) #TODO', '#' #advocate_path
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

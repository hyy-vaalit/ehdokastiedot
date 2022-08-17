ActiveAdmin.register ElectoralAlliance do

  permit_params :name,
                :shorten,
                :expected_candidate_count

  scope :all, :default => true
  scope :without_coalition
  scope :without_advocate_user

  menu :label => " Vaaliliitot", :priority => 3

  index do
    column "Vaaliliiton nimi", :name
    column "Lyhenne", :shorten
    column "Kutsukoodi", :invite_code
    column "Vaalirengas", :electoral_coalition, sortable: false
    column "Vaaliliiton edustaja", :advocate_user, sortable: false
    column "Ehdokkaita odotetaan", :expected_candidate_count
    column "Valmis", :secretarial_freeze

    actions
  end

  show :title => :name do
    attributes_table :name, :shorten do
      row :invite_code
      row("Edustaja") do |a|
        if a.advocate_user.present?
          link_to a.advocate_user.friendly_name, admin_advocate_user_path(a.advocate_user)
        end
      end

      row :created_at
      row :updated_at
      row("candidates") { "#{electoral_alliance.candidates.count} / #{electoral_alliance.expected_candidate_count}" }
      row("ready") { electoral_alliance.secretarial_freeze ? 'Vaaliliitto on merkitty valmiiksi.' : 'Vaaliliittoa ei ole vielä merkitty valmiiksi.' }
    end

    candidates = electoral_alliance.candidates
    panel "Ehdokkaat (#{candidates.count} kpl)" do
      div class:"create-new-candidate-action" do
        if electoral_alliance.secretarial_freeze?
          para "Vaaliliitto on merkitty valmiiksi, eikä siihen pidä tehdä enää muutoksia."
        else
          link_to "Luo uusi ehdokas vaaliliittoon", new_admin_candidate_path(:electoral_alliance_id => electoral_alliance.id)
        end
      end

      div do
        render :partial => "advocates/candidates/list", :locals => { :candidates => electoral_alliance.candidates, :scope => "admin" }
      end
    end
  end

  filter :name
  filter :electoral_coalition
  filter :secretarial_freeze, :as => :select

  sidebar "Edustaja", :only => :show do
    if electoral_alliance.advocate_user
      attributes_table_for electoral_alliance do
        row("Nimi") { link_to electoral_alliance.advocate_user.friendly_name, admin_advocate_user_path(electoral_alliance.advocate_user) }
        row("Viimeksi kirjautunut") { electoral_alliance.advocate_user.current_sign_in_at }
      end
    else
      "Vaalirenkaalle ei ole vielä määritetty edustajaa."
    end
  end

  sidebar "Vaalirengas", :only => :show do
    if electoral_alliance.electoral_coalition
      link_to electoral_alliance.electoral_coalition.name, admin_electoral_coalition_path(electoral_alliance.electoral_coalition)
    else
      "Vaalirenkaalle ei ole vielä määritetty rengasta. Mene vaalirenkaan 'edit'-sivulle ja aseta sieltä renkaaseen kuuluvat liitot."
    end
  end


  sidebar "Ohjeet", :only => :new do
    ul do
      li "Tästä näkymästä luodaan vaaliliitto, jonka tiedot on toimitettu ainoastaan paperilla."
      li "Vaaliliiton luonnin jälkeen HYYn sihteeri syöttää vaaliliiton ehdokkaat."
      li "Kun vaaliliiton ehdokkaat on luotu, HYYn vaalityöntekjiä luo vaaliliiton edustajatunnuksen, jolla edustaja voi syöttää korjauksia ehdokastietoihin."
    end
  end

  form do |f|
    f.inputs 'Vaaliliiton tiedot' do
      f.input :name, :label => "Virallinen nimi"
      f.input :shorten, :label => "Lyhenne (2-6 merkkiä)", :hint => "Käytä mieluiten samaa lyhennettä kuin edellisissä vaaleissa."
      f.input :expected_candidate_count, :label => "Kuinka monta ehdokasta", :hint => "Luvun on täsmättävä paperilomakkeiden määrän kanssa."
    end

    f.actions
  end

  action_item :toggle_filter, :only => :index do
    link_to 'Näytä/piilota hakutoiminnot', '#toggle_filter'
  end

  action_item :mark_alliance_frozen, :only => :show do
    ea = ElectoralAlliance.find_by_id(params[:id])
    link_to 'Merkitse vaaliliitto valmiiksi!', done_admin_electoral_alliance_path if can? :update, electoral_alliance and !ea.secretarial_freeze
  end

  member_action :done do
    if ElectoralAlliance.find_by_id(params[:id]).freeze!
      redirect_to admin_electoral_alliances_path, :notice => "Vaaliliitto on merkitty valmiiksi!"
    else
      redirect_to admin_electoral_alliance_path, :alert => "Vaaliliiton ehdokkaiden määrä ei täsmää perustamisilmoituksessa kerrottuun määrään. Tarkista, että olet syöttänyt täsmälleen yhtä monta ehdokasta kuin vaaliliiton perustamisilmoituksessa on kerrottu."
    end
  end

end

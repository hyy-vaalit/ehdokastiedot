# coding: UTF-8
ActiveAdmin.register ElectoralAlliance do

  scope :all, :default => true
  scope :without_coalition
  scope :without_advocate_user

  menu :label => " Vaaliliitot", :priority => 2

  controller do

    load_and_authorize_resource :except => [:index]

    def index
      if current_admin_user.is_secretary?
        if current_admin_user.electoral_alliance
          redirect_to admin_electoral_alliance_path(current_admin_user.electoral_alliance.id)
        else
          redirect_to new_admin_electoral_alliance_path
        end
      else
        super
      end
    end

    def create
      if current_admin_user.role == 'secretary'
        current_admin_user.electoral_alliance = @electoral_alliance
        current_admin_user.save!
      end
      super
    end

  end

  index do
    column :name
    column :shorten
    column :electoral_coalition, :sortable => false
    column :advocate_user, :sortable => false
    column :expected_candidate_count
    column :secretarial_freeze

    default_actions
  end

  show :title => :name do
    attributes_table :name, :shorten do
      row :created_at
      row :updated_at
      row("candidates") { "#{electoral_alliance.candidates.count} / #{electoral_alliance.expected_candidate_count}" }
      row("ready") { electoral_alliance.secretarial_freeze ? 'Vaaliliitto on merkitty valmiiksi.' : 'Vaaliliittoa ei ole vielä merkitty valmiiksi.' }
    end

    candidates = electoral_alliance.candidates
    panel "Ehdokkaat (#{candidates.count} kpl)" do
      div do
        link_to "Luo uusi ehdokas vaaliliittoon", new_admin_candidate_path(:electoral_alliance_id => electoral_alliance.id)
      end

      div do
        render :partial => "advocates/candidates/list", :locals => { :candidates => electoral_alliance.candidates, :scope => "admin" }
      end
    end
  end

  filter :name
  filter :electoral_coalition
  filter :secretarial_freeze, :as => :select

  sidebar "Asiamies", :only => :show do
    if electoral_alliance.advocate_user
      attributes_table_for electoral_alliance do
        row("Nimi") { link_to electoral_alliance.advocate_user.friendly_name, admin_advocate_user_path(electoral_alliance.advocate_user) }
        row("Viimeksi kirjautunut") { electoral_alliance.advocate_user.current_sign_in_at }
      end
    else
      "Vaalirenkaalle ei ole vielä määritetty asiamiestä."
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
      li "Kun vaaliliiton ehdokkaat on luotu, HYYn vaalityöntekjiä luo vaaliliiton asiamiestunnuksen, jolla asiamies voi syöttää korjauksia ehdokastietoihin."
    end
  end

  form do |f|
    f.inputs 'Vaaliliiton tiedot' do
      f.input :name, :label => "Virallinen nimi"
      f.input :shorten, :label => "Lyhenne (2-6 merkkiä)", :hint => "Käytä mieluiten samaa lyhennettä kuin edellisissä vaaleissa."
      f.input :expected_candidate_count, :label => "Kuinka monta ehdokasta", :hint => "Luvun on täsmättävä paperilomakkeiden määrän kanssa."
    end

    # DEPRECATION WARNING: f.commit_button is deprecated in favour of f.action(:submit) and will be removed from Formtastic after 2.1. Please see ActionsHelper and InputAction or ButtonAction for more information.
    f.buttons
  end

  action_item :only => :index do
    link_to 'Näytä/piilota hakutoiminnot', '#toggle_filter'
  end

  action_item :only => :show do
    ea = ElectoralAlliance.find_by_id(params[:id])
    link_to 'Merkitse vaaliliitto valmiiksi!', done_admin_electoral_alliance_path if can? :update, electoral_alliance and !ea.secretarial_freeze
  end

  member_action :done do
    ea = ElectoralAlliance.find_by_id(params[:id])
    if ea.candidates.count == ea.expected_candidate_count
      ea.freeze!
      current_admin_user.update_attribute :electoral_alliance, nil
      redirect_to admin_electoral_alliances_path, :notice => "Vaaliliitto on merkitty valmiiksi! Voit luoda nyt uuden vaaliliiton."
    else
      redirect_to admin_electoral_alliance_path, :alert => "Vaaliliiton ehdokkaiden määrä ei täsmää perustamisilmoituksessa kerrottuun määrään. Tarkista, että olet syöttänyt täsmälleen yhtä monta ehdokasta kuin vaaliliiton perustamisilmoituksessa on kerrottu."
    end
  end

end

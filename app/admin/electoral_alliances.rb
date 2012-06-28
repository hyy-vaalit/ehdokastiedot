# coding: UTF-8
ActiveAdmin.register ElectoralAlliance do

  scope :all, :default => true
  scope :without_coalition

  menu :label => " Vaaliliitot", :priority => 1

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
    # column :primary_advocate do |alliance|
    #   "#{alliance.primary_advocate_lastname}, #{alliance.primary_advocate_firstname}"
    # end
    # column :secondary_advocate do |alliance|
    #   "#{alliance.secondary_advocate_lastname}, #{alliance.secondary_advocate_firstname}"
    # end
    column :expected_candidate_count
    column :secretarial_freeze

    default_actions
  end

  show :title => :name do
    attributes_table :name, :shorten do
      row("candidates") { "#{electoral_alliance.candidates.count} / #{electoral_alliance.expected_candidate_count}" }
      row("ready") { electoral_alliance.secretarial_freeze ? 'Vaaliliitto on merkitty valmiiksi.' : 'Vaaliliittoa ei ole vielä merkitty valmiiksi.' }
    end
    #attributes_table :primary_advocate_lastname, :primary_advocate_firstname, :primary_advocate_social_security_number, :primary_advocate_address, :primary_advocate_postal_information, :primary_advocate_phone, :primary_advocate_email
    #attributes_table :secondary_advocate_lastname, :secondary_advocate_firstname, :secondary_advocate_social_security_number, :secondary_advocate_address, :secondary_advocate_postal_information, :secondary_advocate_phone, :secondary_advocate_email
  end

  filter :name
  filter :electoral_coalition
  filter :secretarial_freeze, :as => :select

  # sidebar "ADSF Details", :only => :show do
  #   attributes_table_for :advocate_user, :email, :created_at
  # end

  sidebar "Asiamies", :only => :show do
    attributes_table_for electoral_alliance do
      row("Nimi") { link_to electoral_alliance.advocate_user.friendly_name, admin_advocate_user_path(electoral_alliance.advocate_user) }
      row("Viimeksi kirjautunut") { electoral_alliance.advocate_user.current_sign_in_at }
    end
  end

  form do |f|
    f.inputs 'Basic information' do
      f.input :name
      f.input :shorten
      f.input :expected_candidate_count
    end
    # f.inputs 'Primary Advocate' do
    #   f.input :primary_advocate_lastname
    #   f.input :primary_advocate_firstname
    #   f.input :primary_advocate_social_security_number
    #   f.input :primary_advocate_address
    #   f.input :primary_advocate_postal_information
    #   f.input :primary_advocate_phone
    #   f.input :primary_advocate_email
    # end
    # f.inputs 'Secondary Advocate' do
    #   f.input :secondary_advocate_lastname
    #   f.input :secondary_advocate_firstname
    #   f.input :secondary_advocate_social_security_number
    #   f.input :secondary_advocate_address
    #   f.input :secondary_advocate_postal_information
    #   f.input :secondary_advocate_phone
    #   f.input :secondary_advocate_email
    # end

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

  action_item :only => :show do
    ea = ElectoralAlliance.find_by_id(params[:id])
    link_to 'Syötä ehdokkaita vaaliliittoon...', admin_candidates_path(:q => {:electoral_alliance_id_eq => ea.id})
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

# coding: UTF-8
ActiveAdmin.register ElectoralAlliance do

  scope :all, :default => true
  scope :without_coalition

  menu :label => "Vaaliliitot", :priority => 1

  controller do

    load_and_authorize_resource :except => [:index]

    def index
      if current_admin_user.role == 'secretary' and !current_admin_user.electoral_alliance.nil?
        redirect_to admin_electoral_alliance_path(current_admin_user.electoral_alliance.id)
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
    column :primary_advocate do |alliance|
      "#{alliance.primary_advocate_lastname}, #{alliance.primary_advocate_firstname}"
    end
    column :secondary_advocate do |alliance|
      "#{alliance.secondary_advocate_lastname}, #{alliance.secondary_advocate_firstname}"
    end
    column :delivered_candidate_form_amount
    column :secretarial_freeze

    default_actions
  end

  show :title => :name do
    attributes_table :name, :shorten do
      row("candidates") { "#{electoral_alliance.candidates.count} / #{electoral_alliance.delivered_candidate_form_amount}" }
      row("ready") { electoral_alliance.secretarial_freeze ? 'Liiton tiedot ovat valmiina' : 'Liiton tiedot eivät ole valmiina' }
    end
    attributes_table :primary_advocate_lastname, :primary_advocate_firstname, :primary_advocate_social_security_number, :primary_advocate_address, :primary_advocate_postal_information, :primary_advocate_phone, :primary_advocate_email
    attributes_table :secondary_advocate_lastname, :secondary_advocate_firstname, :secondary_advocate_social_security_number, :secondary_advocate_address, :secondary_advocate_postal_information, :secondary_advocate_phone, :secondary_advocate_email
  end

  filter :name
  filter :electoral_coalition
  filter :secretarial_freeze, :as => :select

  form do |f|
    f.inputs 'Basic information' do
      f.input :name
      f.input :shorten
      f.input :delivered_candidate_form_amount
    end
    f.inputs 'Primary Advocate' do
      f.input :primary_advocate_lastname
      f.input :primary_advocate_firstname
      f.input :primary_advocate_social_security_number
      f.input :primary_advocate_address
      f.input :primary_advocate_postal_information
      f.input :primary_advocate_phone
      f.input :primary_advocate_email
    end
    f.inputs 'Secondary Advocate' do
      f.input :secondary_advocate_lastname
      f.input :secondary_advocate_firstname
      f.input :secondary_advocate_social_security_number
      f.input :secondary_advocate_address
      f.input :secondary_advocate_postal_information
      f.input :secondary_advocate_phone
      f.input :secondary_advocate_email
    end
    f.buttons
  end

  action_item :only => :index do
    link_to 'Toggle filter visibility', '#toggle_filter'
  end

  action_item :only => :show do
    ea = ElectoralAlliance.find_by_id(params[:id])
    link_to 'Merkitse vaaliliitto valmiiksi', done_admin_electoral_alliance_path if can? :update, electoral_alliance and !ea.secretarial_freeze
  end

  action_item :only => :show do
    ea = ElectoralAlliance.find_by_id(params[:id])
    link_to 'Vaaliliiton ehdokkaat', admin_candidates_path(:q => {:electoral_alliance_id_eq => ea.id})
  end

  member_action :done do
    ea = ElectoralAlliance.find_by_id(params[:id])
    if ea.candidates.count == ea.delivered_candidate_form_amount
      ea.freeze!
      current_admin_user.update_attribute :electoral_alliance, nil
      redirect_to admin_electoral_alliances_path
    else
      redirect_to admin_electoral_alliance_path, :alert => "Ehdokkaiden määrä ei täsmää kerrottuun määrään"
    end
  end

  collection_action :create_advocates do
    begin
      ElectoralAlliance.create_advocates
      redirect_to admin_electoral_alliances_path, :notice => 'Asiamiestunnukset on luotu'
    rescue
      redirect_to admin_electoral_alliances_path, :alert => 'Varmista, että kaikki vaaliliitot ovat valmiita'
    end
  end

end

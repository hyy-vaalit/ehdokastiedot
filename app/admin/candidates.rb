# coding: UTF-8
ActiveAdmin.register Candidate do
  config.clear_action_items! # Don't show default actions, especially "New candidate"

  before_filter :authorize_this

  menu :label => " Muut ehdokkaat", :priority => 4

  scope :without_alliance, :default => true
  scope :cancelled, :default => true

  controller do

    load_and_authorize_resource :except => [:index]

    # Override default method because we need to set electoral_alliance_id despite
    # mass-assignment protection (which is needed for advocate users).
    def update
      @candidate = Candidate.find(params[:id])

      if @candidate.update_attributes(params[:candidate])
        flash[:notice] = "Muutokset tallennettu."

        respond_with(@alliance) do |format|
          format.html { redirect_to admin_candidate_path(@candidate) }
        end
      else
        super
      end
    end

    # Hack: See comments in form
    def create
      @candidate = Candidate.new(params[:candidate])
      alliance_id = params[:candidate][:active_admin_hack_alliance_id]
      @candidate.electoral_alliance_id = alliance_id

      if @candidate.save
        flash[:notice] = "Ehdokas luotu!"
        redirect_to admin_electoral_alliance_path(alliance_id)
      else
        params["electoral_alliance_id"] = alliance_id
        super
      end
    end

    def authorize_this
      authorize! :read, Candidate
    end

  end

  index do
    text_node "Voit luoda uuden ehdokkaan vaaliliiton sivulta."

    column :candidate_number
    column :lastname
    column :firstname
    column :candidate_name
    column :email
    column :electoral_alliance, :sortable => false
    column :notes

    default_actions
  end

  show :title => :candidate_name do
    attributes_table :lastname, :firstname, :candidate_name, :social_security_number, :address, :postal_information, :email, :faculty, :electoral_alliance, :cancelled, :notes
  end

  filter :candidate_number
  filter :lastname
  filter :firstname
  filter :candidate_name
  filter :social_security_number
  filter :address
  filter :postal_information
  filter :faculty
  filter :electoral_alliance
  filter :email
  filter :notes
  filter :cancelled, :as => :select
  filter :marked_invalid, :as => :select

  # Major hack... there seems to be no way to write into the ActiveAdmin form
  # without losing the form itself... :o
  # And gets better: Mass-assignment protection will raise error before
  # Admin::CandidatesController#create gets called.
  # Therefore create will prematurely fail if electoral_alliance_id is included in params.
  # --> Deliver electoral_alliance_id in hidden hack_alliance_id.
  form do |f|
    alliance_id = f.object.new_record? ? params[:electoral_alliance_id] : f.object.electoral_alliance_id
    alliance = ElectoralAlliance.find_by_id(alliance_id)

    if params[:action] == "new" && alliance.nil?
      panel "Harmin paikka!" do
         "Eksyit uuden ehdokkaan luontisivulle ilman vaaliliittoa. Näin ei olisi pitänyt käydä, dzori!
         <br />
         Mene takaisin vaaliliiton sivulle ja klikkaa sieltä 'Uusi ehdokas'.".html_safe
      end
    else
      f.inputs "Ehdokkaan vaaliliitto: #{alliance.name}" do
        f.input :lastname
        f.input :firstname
        f.input :candidate_name
        f.input :social_security_number
      end
      f.inputs 'Contact' do
        f.input :address
        f.input :postal_information
        f.input :phone_number
        f.input :email
      end
      f.inputs 'Other' do
        f.input :faculty
        f.input :notes, :hint => 'Erota tiedot pilkuilla. Rivinvaihdot korvataan automaattisesti pilkuiksi.'
      end
      f.input :active_admin_hack_alliance_id, :as => :hidden, :value => alliance.id
      f.buttons
    end
  end

  action_item :only => :show do
    candidate = Candidate.find_by_id(params[:id])
    link_to 'Cancel Candidacy', cancel_admin_candidate_path, :confirm => 'Peruutetaanko henkilön ehdokkuus?' unless candidate.cancelled
  end

  action_item :only => :index do
    link_to 'Näytä/piilota hakutoiminnot', '#toggle_filter'
  end

  member_action :cancel, :method => :get do
    candidate = Candidate.find_by_id(params[:id])
    candidate.cancel!
    redirect_to :action => :show
  end

  collection_action :give_numbers do
    if Candidate.give_numbers!
      redirect_to simple_listings_path, :notice => 'Ehdokkaat on numeroitu!'
    else
      redirect_to manage_danger_zone_path, :alert => 'Kaikki liitot eivät ole valmiina tai renkailta puuttuu järjestys.'
    end
  end

end

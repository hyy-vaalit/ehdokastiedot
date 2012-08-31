# coding: UTF-8
ActiveAdmin.register Candidate do
  config.clear_action_items! # Don't show default actions, especially "New candidate"

  before_filter :authorize_this
  before_filter :preserve_default_scope

  menu :label => " Muut ehdokkaat", :priority => 4

  # scope :current_alliance, :default => true do |candidates|
  #   #current_admin_user.electoral_alliance ? current_admin_user.electoral_alliance.candidates : candidates.all
  # end

  scope :without_alliance, :default => true
  scope :cancelled, :default => true

  controller do

    before_filter :assign_alliance

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

    def assign_alliance
      if current_admin_user.role == 'secretary'
        alliance_id = current_admin_user.electoral_alliance_id
        if alliance_id
          cookies['alliance'] = alliance_id
          return true
        end
      end
      cookies['alliance'] = ''
      return true
    end

    def authorize_this
      authorize! :read, Candidate
    end

    def preserve_default_scope
      if current_admin_user.is_secretary?
        params[:scope] = "current_alliance"
      end
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

  collection_action :cancelled_emails do
    require 'csv'
    csv_output = CSV.generate do |csv|
      collection.cancelled.find_each do |candidate|
        csv << [candidate.email]
      end
    end

    filename = 'cancelled_candidacy_emails.csv'
    headers['Content-Type'] = "text/csv"
    headers['Content-Disposition'] = "attachment; filename=#{filename}"
    render :text => csv_output
  end

  collection_action :give_numbers do
    if Candidate.give_numbers!
      redirect_to admin_candidates_path, :notice => 'Ehdokkaat on numeroitu!'
    else
      redirect_to admin_candidates_path, :alert => 'Kaikki liitot eivät ole valmiina tai renkailta puuttuu järjestys.'
    end
  end

end

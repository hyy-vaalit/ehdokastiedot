ActiveAdmin.register Candidate do
  # Hide "delete": Candidate should be cancelled and never deleted.
  actions :all, :except => [:destroy]

  permit_params :lastname,
                :firstname,
                :candidate_name,
                :social_security_number,
                :address,
                :postal_information,
                :phone_number,
                :email,
                :faculty_id,
                :notes,
                :electoral_alliance_id,
                :numbering_order_position

  menu :label => " Muut ehdokkaat", :priority => 4

  scope :without_alliance, :default => true
  scope :cancelled, :default => true

  controller do

    # Override default method because we need to set electoral_alliance_id despite
    # mass-assignment protection (which is needed for advocate users).
    def update
      @candidate = Candidate.find(params[:id])

      if @candidate.update(permitted_params[:candidate])
        flash[:notice] = "Muutokset tallennettu."

        respond_with(@alliance) do |format|
          format.html { redirect_to admin_candidate_path(@candidate) }
        end
      else
        super
      end
    end

    def create
      @candidate = Candidate.new(permitted_params[:candidate])
      alliance_id = params[:candidate][:electoral_alliance_id]

      if @candidate.save
        flash[:notice] = "Ehdokas luotu!"
        redirect_to admin_electoral_alliance_path(alliance_id)
      else
        params["electoral_alliance_id"] = alliance_id
        super
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

    actions
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

  form do |f|
    alliance_id = f.object.new_record? ? params[:electoral_alliance_id] : f.object.electoral_alliance_id

    if params[:action] == "new" && alliance_id.nil?
      panel "Ehdokkaan luominen edellyttää vaaliliittoa" do
        para "Eksyit uuden ehdokkaan luontisivulle ilman vaaliliittoa."

        para "Mene takaisin vaaliliiton sivulle ja klikkaa sieltä 'Uusi ehdokas'."
      end
    else
      # Candidate#electoral_alliance_id can be nil if candidate was in an
      # alliance, but alliance was deleted.
      alliance = ElectoralAlliance.find_by_id(alliance_id)

      alliance_name = alliance.present? ? alliance.name : "Vaaliliitto puuttuu"

      f.inputs "Ehdokkaan vaaliliitto: #{alliance_name}" do
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

      # Prevent potential errors by not allowing to change the alliance.
      # Allow to set alliance only for previously saved candidates who do not
      # have an alliance (ie. alliance was deleted after candidate was created).
      # => Do not display alliance dropdown on NEW or EDIT actions.
      if alliance.present? || f.object.new_record?
        f.input :electoral_alliance_id,
                :as => :hidden,
                :input_html => {:value => alliance.id}
      else
        f.inputs 'Vaaliliitto' do
          f.input :electoral_alliance
        end
      end

      f.actions
    end
  end

  action_item :cancel_candidacy, :only => [ :show, :edit ] do
    candidate = Candidate.find(params[:id])
    if !candidate.cancelled
      link_to 'Peruuta ehdokkuus', cancel_admin_candidate_path, :data => {:confirm => 'Peruutetaanko henkilön ehdokkuus?'}
    end
  end

  action_item :toggle_filter, :only => :index do
    link_to 'Näytä/piilota hakutoiminnot', '#toggle_filter'
  end

  member_action :cancel, :method => :get do
    candidate = Candidate.find(params[:id])
    candidate.cancel!
    redirect_to :action => :show
  end

  collection_action :give_numbers do
    if Candidate.give_numbers!
      redirect_to simple_listings_path, :notice => 'Ehdokkaat on numeroitu!'
    else
      redirect_to manage_danger_zone_path, :alert => 'Kaikki liitot eivät ole valmiina, renkailta puuttuu järjestys tai kaikilla ehdokkailla ei ole liittoa.'
    end
  end

end

ActiveAdmin.register Candidate do

  before_filter :add_notice

  controller do

    load_and_authorize_resource :except => [:index]

    def create
      create! do
        flash[:notice] = "Candidate created!"
        redirect_to new_admin_candidate_path
        return
      end
    end

    def show
      super
      authorize! :report_fixes, @candidate if current_admin_user.role == 'advocate'
    end

    def add_notice
      flash[:notice] = params[:notice] if params[:notice]
    end

  end

  index do
    column :candidate_number
    column :lastname
    column :firstname
    column :candidate_name
    column :social_security_number
    column :address
    column :postal_information
    column :email
    column :faculty
    column :electoral_alliance
    column :notes

    default_actions
  end

  show do
    render 'show'
  end

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

  form do |f|
    f.inputs 'Personal' do
      f.input :lastname
      f.input :firstname
      f.input :candidate_name
      f.input :social_security_number
    end
    f.inputs 'Contact' do
      f.input :address
      f.input :postal_information
      f.input :email
    end
    f.inputs 'Other' do
      f.input :faculty
      f.input :electoral_alliance
      f.input :notes
    end
    f.buttons
  end

  sidebar :fixes, :only => :show

  member_action :report_fixes, :method => :post do
    candidate = Candidate.find_by_id(params[:id])
    df = DataFix.create! :candidate_id => candidate, :field_name => params[:field], :old_value => candidate.send(params[:field]), :new_value => params[:new_value]
    render :json => df
  end

  member_action :apply_fix, :method => :get do
    df = DataFix.find_by_id(params[:fix])
    df.apply!
    redirect_to :action => :show
  end

  action_item :only => :index do
    link_to 'Notify', notify_admin_candidates_path if can? :notify, Candidate
  end

  collection_action :notify do
    candidates = Candidate.all
    candidates.each do |candidate|
      CandidateNotifier.welcome_as_candidate(candidate).deliver
    end
    redirect_to :action => :index, :notice => 'emails sent'
  end

end

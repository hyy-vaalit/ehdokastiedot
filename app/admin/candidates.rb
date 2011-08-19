# coding: UTF-8
ActiveAdmin.register Candidate do

  controller do

    before_filter :assign_alliance

    load_and_authorize_resource :except => [:index]

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

  end

  scope :current_alliance, :default => true do |candidates|
    alliance_id = current_admin_user.electoral_alliance_id
    if alliance_id
      candidates.where(:electoral_alliance_id => alliance_id)
    else
      candidates.all
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
    column :faculty, :sortable => false
    column :electoral_alliance, :sortable => false
    column :notes

    default_actions
  end

  show do
    render 'show'
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

  action_item :only => :show do
    link_to 'Lisää seuraava ehdokas', new_admin_candidate_path
  end

  action_item :only => :show do
    candidate = Candidate.find_by_id(params[:id])
    link_to 'Cancel Candidacy', cancel_admin_candidate_path, :confirm => 'Are you sure' unless candidate.cancelled
  end

  action_item :only => :index do
    link_to 'Cancelled Candidates', cancelled_emails_admin_candidates_path
  end

  action_item :only => :index do
    link_to 'Toggle filter visibility', '#toggle_filter'
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
    Candidate.give_numbers!
    redirect_to admin_candidates_path, :notice => 'Ehdokkaat on numeroitu'
  end

end

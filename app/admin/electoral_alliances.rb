ActiveAdmin.register ElectoralAlliance do

  controller do

    load_and_authorize_resource :except => [:index]

  end

  index do
    column :name
    column :electoral_coalition
    column :primary_advocate do |alliance|
      "#{alliance.primary_advocate_lastname}, #{alliance.primary_advocate_firstname}"
    end
    column :secondary_advocate do |alliance|
      "#{alliance.secondary_advocate_lastname}, #{alliance.secondary_advocate_firstname}"
    end
    column :delivered_candidate_form_amount

    default_actions
  end

  filter :name
  filter :electoral_coalition

  form do |f|
    f.inputs 'Basic information' do
      f.input :name
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

  action_item :only => :show do
    ea = ElectoralAlliance.find_by_id(params[:id])
    link_to 'Done', done_admin_electoral_alliance_path if can? :update, electoral_alliance and !ea.secretarial_freeze
  end

  member_action :done do
    ea = ElectoralAlliance.find_by_id(params[:id])
    if ea.candidates.count == ea.delivered_candidate_form_amount
      ea.freeze!
      redirect_to admin_electoral_alliances_path
    else
      redirect_to admin_electoral_alliance_path, :notice => "Candidate amounts doesn't match"
    end
  end

end

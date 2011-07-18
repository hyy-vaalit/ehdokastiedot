ActiveAdmin.register Candidate do


  controller do

    load_and_authorize_resource :except => [:index]

    def create
      create! do
        flash[:notice] = "Candidate created!"
        redirect_to new_admin_candidate_path
        return
      end
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

end

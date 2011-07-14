ActiveAdmin.register ElectoralAlliance do

  index do
    column :name
    column :electoral_coalition
    column :primary_advocate do |alliance|
      alliance.primary_advocate.name
    end
    column :secondary_advocate do |alliance|
      alliance.secondary_advocate.name
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
      f.fields_for :primary_advocate_attributes do |primary_advocate|
        primary_advocate.inputs do
        primary_advocate.input :lastname
        primary_advocate.input :firstname
        primary_advocate.input :social_security_number
        primary_advocate.input :address
        primary_advocate.input :postal_information
        primary_advocate.input :phone
        primary_advocate.input :email
        end
      end
    end
    f.inputs 'Secondary Advocate' do
      f.fields_for :secondary_advocate_attributes do |secondary_advocate|
        secondary_advocate.inputs do
        secondary_advocate.input :lastname
        secondary_advocate.input :firstname
        secondary_advocate.input :social_security_number
        secondary_advocate.input :address
        secondary_advocate.input :postal_information
        secondary_advocate.input :phone
        secondary_advocate.input :email
        end
      end
    end
    f.buttons
  end

end

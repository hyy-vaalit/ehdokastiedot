ActiveAdmin.register AdminUser do

  index do
    column :email
    column :role
  end

  filter :email
  filter :role

  form do |f|
    f.inputs do
      f.input :email
      f.input :role, :as => :select, :collection => AdminUser::ROLES
    end
    f.buttons
  end

end

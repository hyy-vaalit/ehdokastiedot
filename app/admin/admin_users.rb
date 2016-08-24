ActiveAdmin.register AdminUser do
  permit_params :email, :role

  menu :label => "Admin-tunnukset", :if => proc { can? :manage, AdminUser }, :priority => 11

  index do
    selectable_column
    id_column
    column :email
    column :role
    actions
  end

  filter :email
  filter :role

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :role, :as => :select, :collection => AdminUser::ROLES
    end
    f.actions
  end

end

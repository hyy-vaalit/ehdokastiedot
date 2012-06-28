# coding: UTF-8
ActiveAdmin.register AdminUser do

  menu :label => "Admin-tunnukset", :if => proc { can? :manage, AdminUser }, :priority => 11

  before_filter :authorize_this

  controller do

    def authorize_this
      authorize! :manage, AdminUser
    end

  end

  index do
    column :email
    column :role
    default_actions
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

# coding: UTF-8
ActiveAdmin.register AdvocateUser do

  menu :label => "Asiamiestunnukset", :if => proc { can? :manage, AdvocateUser }, :priority => 12

  before_filter :authorize_this

  controller do

    def authorize_this
      authorize! :manage, AdvocateUser
    end

  end

  index do
    column :email
    column :ssn
    default_actions
  end

  filter :email
  filter :ssn

  form do |f|
    f.inputs do
      f.input :email
      f.input :ssn
    end
    f.buttons
  end

end

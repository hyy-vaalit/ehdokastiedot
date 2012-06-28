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
    column :lastname
    column :firstname
    column :email
    column("Last sign in") { |user| user.current_sign_in_at.localtime if user.current_sign_in_at }
    column("Vaaliliittoja") { |user| user.electoral_alliances.count }
    column :phone_number

    default_actions
  end

  show :title => "User details" do | user |
      panel "Profile Info" do

        attributes_table_for user do
          row("Name") { |user| user.friendly_name }
          row :email
          row :postal_address
          row :postal_code
          row :postal_city
          row :phone_number
       end
     end

     panel "Vaaliliitot (#{user.electoral_alliances.count} kpl)" do

       table_for(user.electoral_alliances) do |t|
         t.column("Valmis") { |alliance| icon(:check) if alliance.secretarial_freeze? }
         t.column("Vaaliliitto") { |alliance| link_to alliance.name, admin_electoral_alliance_path(alliance) }
         t.column("Ehdokkaita syötetty") {|alliance| alliance.candidates.count}
         t.column("Ehdokkaita ilmoitettu") {|alliance| alliance.expected_candidate_count}
         t.column("Kaikki syötetty") {|alliance| alliance.has_all_candidates? ? icon(:check) : ""}
       end
     end
   end

  filter :email
  filter :ssn
  filter :lastname
  filter :firstname

  sidebar "Ohjeet", :only => :new do
    ul do
      li "Tunnuksen luomisen jälkeen asiamiehelle lähetetään salasana sähköpostitse."
      li "Vaaliliiton ensisijainen asiamies syöttää vaaliliiton ehdokkaat."
      li "Ehdokasasettelun päättymisen jälkeen asiamies ei voi enää lisätä ehdokkaita, mutta voi esittää korjauksia tietoihin."
      li "HYYn vaalityöntekijä (admin) hyväkstyy tai hylkää asiamiehen esittämät korjaukset."
    end
  end

  form do |f|
    f.inputs do

      f.input :email
      f.input :ssn
      f.input :firstname
      f.input :lastname
      f.input :postal_address
      f.input :postal_code
      f.input :postal_city
      f.input :phone_number

    end

    f.inputs 'Vaaliliitot' do
      f.input :electoral_alliances,
              :as => :check_boxes,
              :collection => ElectoralAlliance.without_advocate_user.concat(f.object.electoral_alliances)
    end

    f.buttons
  end

end

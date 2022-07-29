ActiveAdmin.register AdvocateUser do

  permit_params :email,
                :student_number,
                :firstname,
                :lastname,
                :phone_number,
                :electoral_alliance_ids

  menu :label => "Edustajatunnukset", :if => proc { can? :manage, AdvocateUser }, :priority => 12

  controller do

    # Override default method because :electoral_alliance_ids is just not
    # available through permitted_params.
    def update
      @advocate_user = AdvocateUser.find(params[:id])

      if @advocate_user.update(permitted_params[:advocate_user])
        @advocate_user.update! electoral_alliance_ids: params[:advocate_user][:electoral_alliance_ids]

        flash[:notice] = "Muutokset tallennettu."
        redirect_to admin_advocate_user_path(@advocate_user)
      else
        super
      end
    end

    # Override default method because :electoral_alliance_ids is just not
    # available through permitted_params.
    def create
      @advocate_user = AdvocateUser.new(permitted_params[:advocate_user])

      if @advocate_user.save
        @advocate_user.update! electoral_alliance_ids: params[:advocate_user][:electoral_alliance_ids]

        flash[:notice] = "Edustaja luotu!"
        redirect_to admin_advocate_user_path(@advocate_user)
      else
        super
      end
    end
  end

  index do
    column :lastname
    column :firstname
    column :email
    column :student_number
    column("Current sign in") { |u| u.current_sign_in_at.localtime if u.current_sign_in_at }
    column("Last sign in") { |u| u.last_sign_in_at.localtime if u.last_sign_in_at }
    column("Vaaliliittoja") { |u| u.electoral_alliances.count }
    column :phone_number

    actions
  end

  show :title => "User details" do | user |
      panel "Profile Info" do
        attributes_table_for user do
          row("Name") { |u| u.friendly_name }
          row :email
          row :phone_number
          row :student_number
          row(:current_sign_in_at) { |u| u.current_sign_in_at.localtime if u.current_sign_in_at }
          row(:last_sign_in_at) { |u| u.last_sign_in_at.localtime if u.last_sign_in_at }
       end
     end

     panel "Vaaliliitot (#{user.electoral_alliances.count} kpl)" do

       table_for(user.electoral_alliances) do |t|
         t.column("Valmis") { |alliance| status_tag('Valmis', class: 'ok') if alliance.secretarial_freeze? }
         t.column("Vaaliliitto") { |alliance| link_to alliance.name, admin_electoral_alliance_path(alliance) }
         t.column("Ehdokkaita syötetty") {|alliance| alliance.candidates.count}
         t.column("Ehdokkaita odotetaan") {|alliance| alliance.expected_candidate_count}
         t.column("Kaikki syötetty") {|alliance| alliance.has_all_candidates? ? status_tag('ok', class: 'ok') : status_tag("Kesken", class: 'in_progress') }
       end
     end
   end

  filter :email
  filter :student_number
  filter :lastname
  filter :firstname

  sidebar "Ohjeet", :only => :new do
    ul do
      li "Tunnuksen luomisen jälkeen edustajalle lähetetään salasana sähköpostitse."
      li "Vaaliliiton ensisijainen edustaja syöttää vaaliliiton ehdokkaat."
      li "Ehdokasasettelun päättymisen jälkeen edustaja ei voi enää lisätä ehdokkaita, mutta voi esittää korjauksia tietoihin."
      li "HYYn vaalityöntekijä (admin) hyväkstyy tai hylkää edustajan esittämät korjaukset."
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :student_number
      f.input :firstname
      f.input :lastname
      f.input :phone_number
    end

    f.inputs 'Vaaliliitot &mdash; Edustajan omat vaaliliitot ja vaaliliitot ilman edustajaa' do
      f.input :electoral_alliances,
              :as => :check_boxes,
              :hint => "Vaihtaaksesi liiton edustajaa, poista liitto ensin nykyiseltä edustajaltaan.",
              :label => "hello there",
              :collection => ( ElectoralAlliance.without_advocate_user + f.object.electoral_alliances )
    end

    f.actions
  end

end

ActiveAdmin.register AdvocateTeam do
  permit_params :name,
    :advocate_user_ids,
    :primary_advocate_user_id

  menu :label => " Tiimit", :priority => 20

  controller do
    # Override default method because :advocate_user_ids is not available in permitted_params.
    def create
      @advocate_team = AdvocateTeam.new(permitted_params[:advocate_team])

      @advocate_team.advocate_user_ids = permitted_params[:advocate_user_ids]

      if @advocate_team.save
        @advocate_team.update!(advocate_user_ids: params[:advocate_team][:advocate_user_ids])

        flash.notice = "Edustajatiimi luotu!"
        redirect_to admin_advocate_team_path(@advocate_team)
      else
        flash.alert = "Edustajatiimin luominen epäonnistui: #{@advocate_team.errors.full_messages}"
        super
      end
    end

    # Override default method because :advocate_user_ids is not available in permitted_params.
    def update
      @advocate_team = AdvocateTeam.find(params[:id])

      if @advocate_team.update(permitted_params[:advocate_team])
        @advocate_team.update!(advocate_user_ids: params[:advocate_team][:advocate_user_ids])

        flash.notice = "Muutokset tallennettu!"
        redirect_to admin_advocate_team_path(@advocate_team)
      else
        flash.alert = "Tallennus epäonnistui: #{@advocate_team.errors.full_messages}"
        super
      end
    end
  end

  index do
    column "Edustajatiimin nimi", :name
    column "Vaalirengas" do |team|
      if team.electoral_coalition.present?
        link_to team.electoral_coalition.shorten, admin_electoral_coalition_path(team.electoral_coalition)
      end
    end
    column "Pääedustaja", :primary_advocate_user
    column "Edustajat", :advocate_users

    actions
  end

  show title: :name do
    attributes_table :name, :created_at, :updated_at do
      row "Vaalirengas" do |team|
        if team.electoral_coalition.present?
          link_to team.electoral_coalition.name, admin_electoral_coalition_path(team.electoral_coalition)
        end
      end
      row("Pääedustaja") { |t| t.primary_advocate_user }
      row("Edustajat") { |t| t.advocate_users }
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :primary_advocate_user_id,
        label: "Pääedustaja",
        as: :select,
        collection: AdvocateUser.pluck("email", "id")
    end

    f.inputs "Edustajat" do
      f.input :advocate_user_ids,
        as: :check_boxes,
        label: "Edustajat",
        hint: "Vaihtoehdoissa näkyvät vain edustajat, joilla ei vielä ole tiimiä.",
        collection: ( AdvocateUser.without_advocate_team + f.object.advocate_users ).pluck("email", "id")
    end

    f.actions
  end
end

ActiveAdmin.register AdvocateTeam do
  permit_params :name,
    :primary_advocate_user_id,
    :advocate_user_ids => []

  menu :label => " Tiimit", :priority => 20

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

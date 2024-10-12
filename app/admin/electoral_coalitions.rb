ActiveAdmin.register ElectoralCoalition do
  permit_params :name,
                :shorten,
                :advocate_team_id,
                :electoral_alliance_ids

  menu :label => " Vaalirenkaat", :priority => 2

  controller do
    # Override default method because :electoral_alliance_ids is not available in permitted_params.
    def update
      @electoral_coalition = ElectoralCoalition.find(params[:id])

      if @electoral_coalition.update(permitted_params[:electoral_coalition])
        @electoral_coalition.update! electoral_alliance_ids: params[:electoral_coalition][:electoral_alliance_ids]

        flash.notice = "Muutokset tallennettu."
        redirect_to admin_electoral_coalition_path(@electoral_coalition)
      else
        flash.alert = "Tallennus epäonnistui: #{@electoral_coalition.errors.full_messages}"
        super
      end
    end

    # Override default method because :electoral_alliance_ids is not available in permitted_params.
    def create
      @electoral_coalition = ElectoralCoalition.new(permitted_params[:electoral_coalition])

      if @electoral_coalition.save
        @electoral_coalition.update! electoral_alliance_ids: params[:electoral_coalition][:electoral_alliance_ids]

        flash.notice = "Vaalirengas luotu!"
        redirect_to admin_electoral_coalition_path(@electoral_coalition)
      else
        flash.alert = "Tallennus epäonnistui: #{@electoral_coalition.errors.full_messages}"
        super
      end
    end
  end

  index do
    column("Vaalirenkaan nimi") { |c| link_to c.name, admin_electoral_coalition_path(c) }
    column "Lyhenne", :shorten
    column("Edustajatiimi") do |c|
      if c.advocate_team.present?
        link_to c.advocate_team.name, admin_advocate_team_path(c.advocate_team)
      end
    end
    column "Vaaliliitot", :electoral_alliances

    actions
  end

  show :title => :name do
    attributes_table :name, :shorten, :created_at, :updated_at do
      row("Pääedustaja") { |c| c&.advocate_team&.primary_advocate_user }

      row("Edustajatiimi") do |c|
        if c.advocate_team
          link_to c.advocate_team.name, admin_advocate_team_path(c.advocate_team)
        end
      end

      if electoral_coalition.electoral_alliances.present?
        row("Vaaliliitot") do
          electoral_coalition.electoral_alliances.map(&:name).join(', ')
        end
      end
    end

    alliances = electoral_coalition.electoral_alliances.by_numbering_order
    panel "Vaaliliitot  (#{alliances.count} kpl)" do
      table_for(alliances) do |t|
        t.column("Valmis") { |alliance| status_tag('Valmis', class: 'ok') if alliance.secretarial_freeze? }
        t.column("Vaaliliitto") { |alliance| link_to alliance.name, admin_electoral_alliance_path(alliance) }
        t.column("Ehdokkaita syötetty") { |alliance| alliance.candidates.count }
        t.column("Ehdokkaita odotetaan") { |alliance| alliance.expected_candidate_count }
        t.column("Kaikki syötetty") { |alliance| alliance.has_all_candidates? ? status_tag('ok', class: 'ok') : status_tag("Kesken", class: 'in_progress') }
        t.column("Edustaja") { |alliance| link_to alliance.advocate_user.friendly_name, admin_advocate_user_path(alliance.advocate_user) if alliance.advocate_user }
      end
    end

  end

  filter :name

  form do |f|
    f.inputs 'Vaalirenkaan tiedot' do
      f.input :name, label: "Vaalirenkaan nimi"
      f.input :shorten, label: "Lyhenne (2-6 merkkiä)", hint: "Käytä samaa lyhennettä kuin edellisissä vaaleissa."
      f.input :advocate_team,
        label: "Edustajatiimi",
        as: :select,
        collection: AdvocateTeam.all,
        member_label: :name
    end
    f.inputs 'Vaalirenkaan liitot' do
      f.input :electoral_alliances,
        as: :check_boxes,
        label: "Vaaliliitot",
        collection: (ElectoralAlliance.without_coalition + f.object.electoral_alliances),
        hint: "Listauksessa ei näytetä vaaliliittoja, jotka kuuluvat johonkin toiseen renkaaseen."
    end
    f.actions
  end

  sidebar :order_alliances, :only => :show do
    render :partial => "order_alliances_sidebar",
           :locals  => { :electoral_coalition => electoral_coalition }
  end

  sidebar :order_coalitions, :only => :index do
    render :partial => "order_coalitions_sidebar",
           :locals  => { :electoral_coalitions => ElectoralCoalition.by_numbering_order }
  end

  action_item :toggle_filter, :only => :index do
    link_to 'Näytä/piilota hakutoiminnot', '#toggle_filter'
  end

  member_action :order_alliances, :method => :post do
    coalition = ElectoralCoalition.find_by_id(params[:id])
    coalition.update_alliance_numbering_order!(params[:alliances])
    redirect_to admin_electoral_coalition_path(coalition.id)
  end

  collection_action :order_coalitions, :method => :post do
    if ElectoralAlliance.without_coalition.count > 0
      redirect_to admin_electoral_coalitions_path, :alert => 'Vaalirenkaita ei voi järjestää ennen kuin kaikilla vaaliliitoilla on rengas. Luo itsenäisille vaaliliitoille rengas, jonka nimenä on vaaliliiton nimi.'
    else
      ElectoralCoalition.update_coalition_numbering_order!(params[:coalitions])
      redirect_to admin_electoral_coalitions_path
    end
  end

end

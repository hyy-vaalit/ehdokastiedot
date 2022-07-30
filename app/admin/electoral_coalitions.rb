ActiveAdmin.register ElectoralCoalition do

  permit_params :name,
                :shorten,
                :electoral_alliance_ids

  menu :label => " Vaalirenkaat", :priority => 3

  controller do
    # Override default method because :electoral_alliance_ids is not available in permitted_params.
    def update
      @electoral_coalition = ElectoralCoalition.find(params[:id])

      if @electoral_coalition.update(permitted_params[:electoral_coalition])
        @electoral_coalition.update! electoral_alliance_ids: params[:electoral_coalition][:electoral_alliance_ids]

        flash[:notice] = "Muutokset tallennettu."
        redirect_to admin_electoral_coalition_path(@electoral_coalition)
      else
        super
      end
    end

    # Override default method because :electoral_alliance_ids is not available in permitted_params.
    def create
      @electoral_coalition = ElectoralCoalition.new(permitted_params[:electoral_coalition])

      if @electoral_coalition.save
        @electoral_coalition.update! electoral_alliance_ids: params[:electoral_coalition][:electoral_alliance_ids]

        flash[:notice] = "Vaalirengas luotu!"
        redirect_to admin_electoral_coalition_path(@electoral_coalition)
      else
        super
      end
    end
  end

  index do
    column :name
    column :shorten
    column :alliances do |coalition|
      coalition.electoral_alliances.by_numbering_order.map(&:name).join(', ')
    end

    actions
  end

  show :title => :name do
    attributes_table :name, :shorten, :created_at, :updated_at do
      row("electoral_alliances") { electoral_coalition.electoral_alliances.map(&:name).join(', ')} if electoral_coalition.electoral_alliances.count > 1
    end

    alliances = electoral_coalition.electoral_alliances.by_numbering_order
    panel "Vaaliliitot  (#{alliances.count} kpl)" do
      table_for(alliances) do |t|
        t.column("Valmis") { |alliance| status_tag('Valmis', class: 'ok') if alliance.secretarial_freeze? }
        t.column("Vaaliliitto") { |alliance| link_to alliance.name, admin_electoral_alliance_path(alliance) }
        t.column("Ehdokkaita syötetty") {|alliance| alliance.candidates.count}
        t.column("Ehdokkaita odotetaan") {|alliance| alliance.expected_candidate_count}
        t.column("Kaikki syötetty") {|alliance| alliance.has_all_candidates? ? status_tag('ok', class: 'ok') : status_tag("Kesken", class: 'in_progress') }
        t.column("Edustaja") {|alliance| link_to alliance.advocate_user.friendly_name, admin_advocate_user_path(alliance.advocate_user) if alliance.advocate_user}
      end
    end

  end

  filter :name

  form do |f|
    f.inputs 'Vaalirenkaan tiedot' do
      f.input :name
      f.input :shorten
    end
    f.inputs 'Vaalirenkaan liitot' do
      f.input :electoral_alliances, :as => :check_boxes, :collection => (ElectoralAlliance.without_coalition + f.object.electoral_alliances),
                                    :hint => "Tässä ovat näkyvissä ainoastaan renkaisiin kuulumattomat liitot. Luo vaaliliitto ennen vaalirenkaan luomista."
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

# coding: UTF-8
ActiveAdmin.register ElectoralCoalition do

  before_filter :authorize_this

  menu :label => " Vaalirenkaat", :priority => 2

  controller do

    def authorize_this
      authorize! :manage, ElectoralCoalition
    end

  end

  index do
    column :name
    column :shorten
    column :alliances do |coalition|
      coalition.electoral_alliances.map(&:name).join(', ')
    end

    default_actions
  end

  show :title => :name do
    attributes_table :name, :shorten do
      row("electoral_alliances") { electoral_coalition.electoral_alliances.map(&:name).join(', ')} if electoral_coalition.electoral_alliances.count > 1
    end
  end

  filter :name

  form do |f|
    f.inputs 'Basic information' do
      f.input :name
      f.input :shorten
    end
    f.inputs 'Alliances' do
      f.input :electoral_alliances, :as => :check_boxes, :collection => ElectoralAlliance.without_coalition.concat(f.object.electoral_alliances)
    end
    f.buttons
  end

  sidebar :order_alliances, :only => :show
  sidebar :order_coalitions, :only => :index

  action_item :only => :index do
    link_to 'Näytä/piilota hakutoiminnot', '#toggle_filter'
  end

  member_action :order_alliances, :method => :post do
    coalition = ElectoralCoalition.find_by_id(params[:id])
    coalition.order_alliances(params[:alliances])
    redirect_to admin_electoral_coalition_path(coalition.id)
  end

  collection_action :order_coalitions, :method => :post do
    if ElectoralAlliance.without_coalition.count > 0
      redirect_to admin_electoral_coalitions_path, :alert => 'Vaalirenkaita ei voi järjestää ennen kuin kaikilla vaaliliitoilla on rengas. Luo itsenäisille vaaliliitoille rengas, jonka nimenä on vaaliliiton nimi.'
    else
      ElectoralCoalition.give_orders(params[:coalitions])
      redirect_to admin_electoral_coalitions_path
    end
  end

end

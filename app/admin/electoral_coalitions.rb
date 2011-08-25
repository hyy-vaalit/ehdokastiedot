# coding: UTF-8
ActiveAdmin.register ElectoralCoalition do

  before_filter :authorize_this

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
    link_to 'Toggle sidebar visibility', '#toggle_filter'
  end

  member_action :order_alliances, :method => :post do
    coalition = ElectoralCoalition.find_by_id(params[:id])
    coalition.order_alliances(params[:alliances])
    redirect_to admin_electoral_coalition_path(coalition.id)
  end

  collection_action :order_coalitions, :method => :post do
    if ElectoralAlliance.without_coalition.count > 0
      redirect_to admin_electoral_coalitions_path, :alert => 'Ei voi järjestää, sillä löytyi irrallisia vaaliliittoja'
    else
      ElectoralCoalition.give_orders(params[:coalitions])
      redirect_to admin_electoral_coalitions_path
    end
  end

end

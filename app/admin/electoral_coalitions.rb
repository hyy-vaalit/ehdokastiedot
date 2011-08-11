ActiveAdmin.register ElectoralCoalition do

  index do
    column :name
    column :alliances do |coalition|
      coalition.electoral_alliances.map(&:name).join(', ')
    end

    default_actions
  end

  filter :name

  form do |f|
    f.inputs 'Basic information' do
      f.input :name
    end
    f.inputs 'Alliances' do
      f.input :electoral_alliances, :as => :check_boxes, :collection => ElectoralAlliance.without_coalition.concat(f.object.electoral_alliances)
    end
    f.inputs 'Order' do
      f.input :number_order
    end
    f.buttons
  end

  sidebar :order_alliances, :only => :show
  sidebar :order_coalitions, :only => :index

  member_action :order_alliances, :method => :post do
    ElectoralCoalition.find_by_id(params[:id]).order_alliances(params[:alliances])
    redirect_to :action => :show
  end

  collection_action :order_coalitions, :method => :post do
    ElectoralCoalition.give_orders(params[:coalitions])
    redirect_to :action => :index
  end

end

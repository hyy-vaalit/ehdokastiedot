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
      f.input :electoral_alliances
    end
    f.inputs 'Order' do
      f.input :number_order
    end
    f.buttons
  end

  sidebar :order_alliances, :only => :show

  member_action :order_alliances, :method => :post do
    ElectoralCoalition.find_by_id(params[:id]).order_alliances(params[:alliances])
    redirect_to :action => :show
  end

end

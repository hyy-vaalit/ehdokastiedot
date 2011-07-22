ActiveAdmin.register ElectoralCoalition do

  index do
    column :name
    column :alliances do |coalition|
      coalition.electoral_alliances.map(&:name).join(', ')
    end
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

end

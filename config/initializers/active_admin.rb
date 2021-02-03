# For config options, see the config file in
# https://github.com/activeadmin/activeadmin/blob/master/lib/generators/active_admin/install/templates/active_admin.rb.erb
ActiveAdmin.setup do |config|

  config.site_title = "Vaalit"
  config.authorization_adapter = ActiveAdmin::CanCanAdapter
  config.default_namespace = :admin
  config.authentication_method = :authenticate_admin_user!
  config.current_user_method = :current_admin_user
  config.before_action :authorize_admin_access
  config.batch_actions = false
  config.root_to = 'dashboard#index'
  config.comments = false

  # == CSV options
  # Set the CSV builder separator (default is ",")
  # config.csv_column_separator = ','
  #
  # Force the use of quotes
  # config.csv_options = { force_quotes: true }

  # config.logout_link_path = :destroy_admin_user_session_path
  # config.logout_link_method = :get

  # == Register Stylesheets & Javascripts
  #
  # We recomend using the built in Active Admin layout and loading
  # up your own stylesheets / javascripts to customize the look
  # and feel.
end

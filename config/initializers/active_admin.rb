ActiveAdmin.setup do |config|

  config.site_title = "Vaalit"
  config.default_namespace = :admin
  config.authentication_method = :authenticate_admin_user!
  config.current_user_method = :current_admin_user


  # == Admin Comments
  #
  # Admin notes allow you to add notes to any model
  #
  # Admin notes are enabled by default in the default
  # namespace only. You can turn them on in a namesapce
  # by adding them to the comments array.
  #
  # config.allow_comments_in = [:admin]


  # == Controller Filters
  #
  # You can add before, after and around filters to all of your
  # Active Admin resources from here.
  #
  config.before_filter :authorize_admin_access


  # == Register Stylesheets & Javascripts
  #
  # We recomend using the built in Active Admin layout and loading
  # up your own stylesheets / javascripts to customize the look
  # and feel.
  #
  # To load a stylesheet:
  config.register_stylesheet 'custom_admin.css'

  # To load a javascript file:
  config.register_javascript 'candidate_form.js'
  config.register_javascript 'candidate_fix.js'
end

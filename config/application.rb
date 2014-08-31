require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

# If you want your assets lazily compiled in production, use this line
# Bundler.require(:default, :assets, Rails.env)

module Vaalit
  class Application < Rails::Application

    # [deprecated] I18n.enforce_available_locales will default to true in the future.
    # If you really want to skip validation of your locale you can
    # set I18n.enforce_available_locales = false to avoid this message.
    I18n.enforce_available_locales = true

    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # If your application is using an "/assets" route for a resource you may
    # want change the prefix used for assets to avoid conflicts:
    # Defaults to '/assets'
    #config.assets.prefix = '/asset-files'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib)

    # Use decorators instead of helpers.
    # If you want a helper, you can still call "rails generate helper" directly.
    config.generators do |g|
      g.helper false
    end

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Helsinki'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Workaround for Active Admin 0.5.1 bug which causes "Translation missing" errors.
    # Rails console:
    #  > I18n.t("active_admin.dashboard")
    #  => "translation missing: en.active_admin.dashboard"
    #  > I18n.reload!
    #  => false
    #  > I18n.t("active_admin.dashboard")
    #  => "Dashboard"
    #
    # TODO: Remove this if Active Admin is someday updated to >= 0.6.0
    #       OR if this is no longer needed in Rails 3.2.x
    # https://github.com/activeadmin/activeadmin/issues/999
    # https://github.com/jbhannah/active_admin/commit/0f0bd9e6f46b09c1a089c0b580a08f7f250f40af#difffe974f7bed62b0ccd001669c614ea0c3R57
    #
    # This does not fix Active Admin's translations in the Rails console.
    config.after_initialize do |app|
      if defined?(ActiveAdmin) and ActiveAdmin.application
        # Try enforce reloading after app bootup
        Rails.logger.debug("Reloading AA")
        ActiveAdmin.application.unload!
        I18n.reload!
        self.reload_routes!
      end
    end
  end
end

source 'https://rubygems.org'

ruby '2.0.0' # For Heroku

gem 'rails', '3.2.18'

# Needed for the asset pipeline
group :assets do
  gem 'sass-rails',   '~> 3.2.6'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier',     '>= 1.0.3'
end

gem 'jquery-rails'
gem "aws-s3", :require => "aws/s3"
gem 'pg'
gem 'rollbar', '~> 1.0.0' # Airbrake competitor
gem 'sendgrid' # required because Mailers use sendgrid gem's methods
gem 'foreigner'

# gems that cannot be updated without changes to the code
gem 'activeadmin', '0.5.1'  # dashboard is removed in 0.6.0

# versions frozen before complete update for Rails 3.1.x
gem 'ranked-model', "~> 0.0.5"
gem 'cancan', "~> 1.6.7"
gem 'json_builder', '~> 3.1.7'
gem 'devise', "~> 1.5.3"
gem 'draper', '0.7.3'       # draper 0.12.x doesn't work with Rails 3.0

# gems that were updated when project was updated to Rails 3.2
gem 'delayed_job', '~> 3.0'
gem 'delayed_job_active_record'
gem 'formtastic', '~> 3.0'

# gem 'state_machine' # TODO: Ensure this is no longer used

group :development, :test do
  gem 'database_cleaner'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'guard-rspec'
  gem 'growl'
  gem 'taps'
  gem 'byebug'
end

group :test do
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'capybara'
  gem 'spork'
end

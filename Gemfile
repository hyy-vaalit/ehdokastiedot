source 'http://rubygems.org'

gem 'rails', '3.0.20'       # deprecation warnings for Rails 3.1
gem 'delayed_job', '~> 2.1' # incompatible with 3.x
gem 'formtastic', '~> 2.1'  # deprecation warnings
gem 'draper', '0.7.3'       # draper 0.12.x doesn't work with Rails 3.0
gem 'json_builder'

gem 'activeadmin'
gem 'ranked-model'
gem 'cancan'

gem "aws-s3", :require => "aws/s3"

gem 'pg'
gem 'hoptoad_notifier'
gem 'jquery-rails'
gem 'sass'

gem 'redis'

gem 'state_machine'
gem 'sendgrid' # required because Mailers use sendgrid gem's methods
gem 'foreigner'

group :development, :test do
  gem 'database_cleaner'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'cover_me'
  gem 'factory_girl_rails'
  gem 'guard-rspec'
  gem 'growl'
  gem 'taps'
  gem 'ruby-debug19'
end

group :test do
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'capybara'
  gem 'spork'
end

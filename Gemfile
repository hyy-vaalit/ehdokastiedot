source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

ruby '4.0.5' # For Heroku, see also file .ruby-version

gem 'rails', '~> 8.1.3'
gem 'rails-i18n', '~> 8.1.0' # fi/sv/en translations for Rails defaults (validation errors, dates)
gem 'bootsnap'
gem 'pg'
gem 'puma'
gem 'sassc-rails'

gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'ruby-saml' # Haka authentication

gem 'aws-sdk-rails', '~> 5'
gem 'aws-actionmailer-ses', '~> 1'

gem 'rollbar'

gem 'activeadmin', '~> 3.5'
gem 'inherited_resources'

gem 'ranked-model'
gem 'cancancan'
gem 'devise'

gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'formtastic'

group :development, :test do
  gem 'byebug', platform: :mri # usage: write "debugger" somewhere in code
  gem 'database_cleaner'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rubocop-rails'
  gem 'factory_bot_rails'
  gem 'guard-rspec'
  gem 'dotenv-rails'
  gem 'foreman'
  gem 'letter_opener'
end

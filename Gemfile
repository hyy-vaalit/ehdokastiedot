source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

ruby '3.3.9' # For Heroku, see also file .ruby-version

gem 'rails', '~> 7.2.2.1'
gem 'bootsnap'
gem 'pg'
gem 'puma'
gem 'sassc-rails'

gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'ruby-saml' # Haka authentication

gem 'json_builder' #TODO:Voiko käyttää jbuilder

gem "aws-sdk-rails", "~> 3.0"

gem 'rollbar'

gem 'activeadmin', '~> 3.3.0'
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

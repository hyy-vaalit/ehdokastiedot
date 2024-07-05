source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

ruby '3.1.6' # For Heroku, see also file .ruby-version

gem 'rails', '~> 7.1.3.4'
gem 'bootsnap'
gem 'pg'
gem 'puma'
# gem 'webpacker'
gem 'sassc-rails'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'ruby-saml' # Haka authentication

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
##TODO: gem 'jbuilder', '~> 2.5'
gem 'json_builder' #TODO:Voiko käyttää jbuilder

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Provides aws-sdk-ses
# NB. S3 is not actually used anymore as S3 publishing is by Vaalitulostin.
# Newer version >=3.x requires Rails >=5.2
gem "aws-sdk-rails", '~> 2.1.0'

gem 'rollbar'

gem 'pry-rails' # friendlier rails console

gem 'activeadmin', '~> 3.2.2'
gem 'inherited_resources', github: 'activeadmin/inherited_resources'

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
  gem 'rubocop'
  gem 'factory_bot_rails'
  gem 'guard-rspec'
  gem 'dotenv-rails'
  gem 'foreman'
  gem 'letter_opener'
end

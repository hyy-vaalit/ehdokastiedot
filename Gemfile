source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

ruby '2.6.6' # For Heroku, see also file .ruby-version

gem 'rails', '~> 5.2.4.4'
gem 'pg'
gem 'puma'
gem 'sass-rails'
gem 'uglifier'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'jquery-rails'
gem 'jquery-ui-rails'

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

# gems that cannot be updated without changes to the code
# gem 'activeadmin', '0.5.1'  # dashboard is removed in 0.6.0
gem 'activeadmin', '2.4.0'
gem 'inherited_resources', github: 'activeadmin/inherited_resources', branch: 'v1.9.0'

# versions frozen before complete update for Rails 3.1.x
gem 'ranked-model'
gem 'cancancan'
gem 'devise'
gem 'draper'

# gems that were updated when project was updated to Rails 3.2
gem 'delayed_job', '~> 4.1'
gem 'delayed_job_active_record'
gem 'formtastic'

group :development, :test do
  gem 'byebug', platform: :mri # usage: write "debugger" somewhere in code
  gem 'database_cleaner'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'guard-rspec'
  gem 'dotenv-rails'
  gem 'foreman'
end

group :development do
  gem 'spring' # keep application running in the background. Read more: https://github.com/rails/spring
  gem 'spring-watcher-listen'
end

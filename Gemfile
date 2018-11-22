source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Full text search
gem 'pg_search', '~> 2.1'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Token based authentication.
gem 'jwt', '~> 2.1.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7.0'
#Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Provides support for Cross-Origin Resource Sharing (CORS) 
gem 'rack-cors', require: 'rack/cors'

# For authorization
gem 'pundit', '~> 2.0.0'

# For paginate records
gem 'will_paginate', '~> 3.1.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # use pry in console
  gem 'pry-rails', '~> 0.3.4'
  # For testing
  gem 'rspec-rails', '~> 3.6'
  # Autoload dotenv in Rails.
  gem 'dotenv-rails', '~> 2.5.0'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # A fixtures replacement
  gem 'factory_bot_rails', '~> 4.11.1'
  # it provides RSpec that test common Rails functionality
  gem 'shoulda-matchers', '~> 3.1'
  # For generating fake data
  gem 'faker', '~> 1.9.1'
  # Cleans our test database 
  gem 'database_cleaner', '~> 1.7.0'
end



# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

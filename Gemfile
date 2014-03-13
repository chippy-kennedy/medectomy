source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'jquery-turbolinks'

# UI Element for JQuery
gem 'jquery-ui-sass-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Bootstrap for Rails 4
gem 'bootstrap-sass'

# Fonts
gem "font-awesome-rails"

# Animate.css for Rails
gem "animate-rails"

# Flot Graph API
gem 'flot-rails', :git => "https://github.com/Kjarrigan/flot-rails.git"

# Authentication w/ Devise, Rolify, & CanCan
gem 'devise'
gem 'rolify'
gem 'cancan'

# gibbon for MailChimp integration
gem 'gibbon'

# Amazon's official AWS SDK
gem "aws-sdk"

group :deployment do 
	# Use PostgreSQL as database for Active Record
	gem 'pg'
end

group :development do
  gem 'faker'
  gem 'database_cleaner', '< 1.1.0'
end

group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'guard-rspec'
end

group :test, :development do
	# Use sqlite3 as the database for Active Record
	gem 'sqlite3'
	# Use debugger
	gem 'debugger'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development
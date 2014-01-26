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

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Bootstrap 3.0.0 for Rails 4
gem 'bootstrap-sass', '~> 3.0.3.0'

# Animate.css for Rails
gem "animate-rails"

# devise for authentication
gem 'devise'

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
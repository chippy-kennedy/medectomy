source 'https://rubygems.org'

ruby '2.0.0' 

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use sqlite3 as the database for Active Record
gem 'sqlite3', group: [:development, :test]


#3. Do we add the following?
#group :development do
  #Put things here for Dev changes
#end

group :production do
	# for heroku analytics
  gem 'newrelic_rpm'
	# Use PostgreSQL as database for Active Record
	gem 'pg'
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

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

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

#*Might need to be taken out for Production
#*Needed for Develpoment I think:
gem 'therubyracer', '0.11.0beta5'
gem 'libv8', '~> 3.11.8'

# Bootstrap 3.0.0 for Rails 4
gem 'anjlab-bootstrap-rails', '~> 3.0.0.3', :require => 'bootstrap-rails'

# Animate.css for Rails
gem "animate-rails"

# devise for authentication
gem 'devise', '3.0.1'

# gibbon for MailChimp integration
gem 'gibbon'

group :development do
  gem 'debugger'
  gem 'faker'
  gem 'database_cleaner', '< 1.1.0'
end

group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'guard-rspec'
end

# extends heroku functionality
gem 'rails_12factor', group: :production
	
# Use debugger
gem 'debugger', group: [:development, :test]

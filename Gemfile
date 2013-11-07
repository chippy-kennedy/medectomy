source 'https://rubygems.org'

#Chippy's TroubleShooting!
gem 'rails_12factor', group: :production


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use Postgress as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
#Chippy: Unknown if I fixed the prelaunch_deployment branch .CSS files to fit this format. Needs verification!!
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
#Rails 4.0: rubyrace not needed and takes up too much memory
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

# Use debugger
gem 'debugger', group: [:development, :test]

#Specify which version of Ruby is being Used
#Upgraded to 2.0.0!!
ruby "2.0.0"

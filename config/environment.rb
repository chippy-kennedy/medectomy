# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Medectomy::Application.initialize!

# Custom date time format
Time::DATE_FORMATS[:month_day_year] = "%B %d, %Y"

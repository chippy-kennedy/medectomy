# Rake task to generate testing data for use in the development environment

#require 'populator'
require 'faker'
require 'ext/faker'
require 'database_cleaner'

#include AWS::S3

if Rails.env.development?

	namespace :note do
		
		desc ""
		task :clean => :environment do

			# clean the database
			DatabaseCleaner.strategy = :truncation
			DatabaseCleaner.start
			DatabaseCleaner.clean

		end

		desc ""
		task :setup => :environment do 

			session = GoogleDrive.login(GDATA_CONFIG[Rails.env]["username"], GDATA_CONFIG[Rails.env]["password"])

		end

	end

else
	puts "'Development.rake' should only be run in the development environment."
end



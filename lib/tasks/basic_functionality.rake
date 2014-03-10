# Rake task to generate testing data for use in the development environment

#require 'populator'
require 'faker'
require 'ext/faker'
require 'database_cleaner'
require 'fileutils'

#include AWS::S3

if Rails.env.development?

	namespace :dev do

		task :clean => :environment do 

			# clean the database
			DatabaseCleaner.strategy = :truncation
			DatabaseCleaner.start
			DatabaseCleaner.clean
		
		end

		desc "creates ten different universities and their domain affiliations"
		task :create_universities => :environment do

		end

		desc "creates fifty different student users with various domain affiliations"
		task :create_users => :environment do

		end

		desc "creates random courses and chapters"
		task :create_course_chapter do

		end

		desc "enrolls students in courses randomly"
		task :create_enrollments do
		end
		

	end


else
	puts "'Development.rake' should only be run in the development environment."
end
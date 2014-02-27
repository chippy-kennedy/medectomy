# Rake task to generate testing data for use in the development environment

#require 'populator'
require 'faker'
require 'ext/faker'
require 'database_cleaner'
require 'fileutils'

#include AWS::S3

if Rails.env.development?

	namespace :dev do

		# holds an AWS S3 object
		@s3 = nil
		@medectomy_bucket = nil
		
		desc "cleans development files & deletes all files from medectomy S3"
		task :clean_all => :environment do

			# clean the database
			DatabaseCleaner.strategy = :truncation
			DatabaseCleaner.start
			DatabaseCleaner.clean

			connect_s3

			# iterate and delete all files and folders 
			@medectomy_bucket.objects.each do |file|
				file.delete
				puts "Deleted File: '#{file.key}'"
			end

			disconnect_s3
		end

		desc "cleans databases"
		task :clean_db => :environment do

			# clean the database
			DatabaseCleaner.strategy = :truncation
			DatabaseCleaner.start
			DatabaseCleaner.clean
			
		end

		desc ""
		task :setup => :environment do 

			connect_s3

			# create course folder
			@medectomy_bucket.objects.create(Pathname.new("Courses/"), "")
			puts "Created course directory"

			disconnect_s3

		end

		task :accounts_and_univ => :environment do
			# create ten universities and their corresponding domains
			University.create(name: "Case Western Reserve").domains.create(name: "case.edu")
			University.create(name: "University of Southern California").domains.create(name: "usc.edu")
			University.create(name: "Georgia Tech").domains.create(name: "gatech.edu")
			University.create(name: "Purdue").domains.create(name: "purdue.edu")
			University.create(name: "Virginia Tech").domains.create(name: "vt.edu")
			University.create(name: "Emory").domains.create(name: "emory.edu")
			University.create(name: "Harvard").domains.create(name: "harvard.edu")
			University.create(name: "Princeton").domains.create(name: "princeton.edu")
			University.create(name: "Duke").domains.create(name: "duke.edu")
			University.create(name: "Ohio State").domains.create(name: "osu.edu")

			# create 100 different students
			# password for all accounts 'test1234'
			100.times do
				User.create(
					first_name: Faker::Name.first_name,
					last_name: Faker::Name.last_name,
					email: "#{Faker::Internet.user_name}@#{Faker::University.domain}",
					encrypted_password: '$2a$10$dggRr7MIW2QX0i7sMSBk6.ZlSctxBS7GBQioPDGIlZcC1ZPtKe6Eu'
				)
			end
		end
	end

else
	puts "'Development.rake' should only be run in the development environment."
end



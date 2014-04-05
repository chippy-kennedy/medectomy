# Rake task to generate testing data for use in the development environment

require 'faker'
require 'ext/faker'
require 'database_cleaner'
require 'fileutils'

#include AWS::S3

	namespace :dev do

    task :clean_basic => :environment do 

			# clean the database
      DatabaseCleaner.strategy = :truncation, {:only => %w[users universities enrollments]}
			DatabaseCleaner.start
			DatabaseCleaner.clean
		
		end
    
    task :test => :environment  do
      Rake::Task['dev:create_unversities'].invoke
      Rake::Task['dev:create_users'].invoke
		end
    
		desc "creates ten different universities and their domain affiliations"
		task :create_universities => :environment do
      
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
      
		end

		desc "creates fifty different student users with various domain affiliations"
		task :create_users => :environment do
      50.times do 
        User.create(
          email: "#{Faker::Internet.user_name}@#{Faker::University.domain}",
          password: "test1234",
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name
          )
      end
		end

		desc "enrolls students in courses randomly"
		task :create_enrollments => :environment do
      Course.create(
        id: '1',
        name: "Microbiology",
        description: "Microbiology description goes here",
        icon_lg: "images/microscope-icon.png"
        )
		end
		

	end
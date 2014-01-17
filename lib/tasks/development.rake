# Rake task to generate testing data for use in the development environment

#require 'populator'
require 'faker'
require 'ext/faker'
require 'database_cleaner'

if Rails.env.development?

	namespace :dev do
		
		task :clean => :environment do

			# clean the database
			DatabaseCleaner.strategy = :truncation
			DatabaseCleaner.start
			DatabaseCleaner.clean

		end

		task :add_content => :environment do

			# initiate connection to Amazon S3
			AWS::S3::Base.establish_connection!(
				access_key_id: amazon__s3_access_key_id, 
				secret_access_key: amazon_s3_secret_access_key
			)

			# upload course material
			
			
			Course.create(name: "Microbiology", description: "Teach me how to Microbiology. Everybody Microbiology. I Microbiology real smooth.", image_lg: "", image_sm: "")

		end

end

else

	puts "'Development.rake' should only be run in the development environment."

end
# Rake task to generate testing data for use in the development environment

#require 'populator'
require 'faker'
require 'ext/faker'
require 'database_cleaner'

include AWS::S3

if Rails.env.development?

	namespace :dev do
		
		task :clean => :environment do

			# clean the database
			DatabaseCleaner.strategy = :truncation
			DatabaseCleaner.start
			DatabaseCleaner.clean

			#initiate connection to Amazon S3
			connect_s3
			medectomy_bucket = Bucket.find('medectomy')
			medectomy_bucket.delete_all()

		end

		task :setup => :environment do 

			connect_s3
			medectomy_bucket = Bucket.find('medectomy')

			# create course folder and chapter folder within
			S3Object.store("Course/Chapter/", "", "medectomy")



		end

		task :add_content => :environment do |t, args|

			connect_s3			

			Dir.glob(S3_CONFIG[Rails.env]["content_directory"]).each do |file|

				file_name = File.basename(file)
				file_name.split("_").each { |x| puts x}

				File.extname(file)

				case File.extname(file)

					when ".png"

						if file_name.include?("#lg")
							
						elsif file_name.include?("#sm")

						end

					when ".txt"
					
					when ".html"

					else 
						puts "Invalid file: #{File.basename(file)}"	
				end

			end	


			# upload course material
			
			#Course.create(name: "Microbiology", description: "Teach me how to Microbiology. Everybody Microbiology. I Microbiology real smooth.", image_lg: "", image_sm: "")

		end

		# initiates connection to Amazon S3
		def connect_s3

			Base.establish_connection!(
				access_key_id: S3_CONFIG[Rails.env]["s3_key"], 
				secret_access_key: S3_CONFIG[Rails.env]["s3_secret"]
			)

		end

	end

else

	puts "'Development.rake' should only be run in the development environment."

end












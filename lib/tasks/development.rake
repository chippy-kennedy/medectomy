# Rake task to generate testing data for use in the development environment

#require 'populator'
require 'faker'
require 'ext/faker'
require 'database_cleaner'

#include AWS::S3

if Rails.env.development?

	namespace :dev do

		# holds an AWS S3 object
		@s3 = nil
		@medectomy_bucket = nil
		
		desc "cleans development files & deletes all files from medectomy S3"
		task :clean => :environment do

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

		desc ""
		task :setup => :environment do 

			connect_s3

			# create course folder
			@medectomy_bucket.objects.create(Pathname.new("Courses/"), "")
			puts "Created course directory"

			disconnect_s3

		end

		task :add_content => :environment do 

			connect_s3			

			Dir.glob(S3_CONFIG[Rails.env]["content_directory"]).each do |local_file_path|

				file_name = File.basename(local_file_path)

				#Extracts name of the course from the file
				course_name = file_name.split("_")[0]
				#Extracts the chapter name from the file
				chapter_name = file_name.split("_")[1].split("\#")[0]
				location_to_store = "Courses/#{course_name}/#{chapter_name}/"

				case File.extname(local_file_path)

				when ".png"

					if file_name.include?("#lg")
						location_to_store+="large_images/#{file_name}"
						add_new_content(location_to_store, local_file_path)
					elsif file_name.include?("#sm")
						location_to_store+="small_images/#{file_name}"
						add_new_content(location_to_store, local_file_path)
					end

				when ".txt"

					location_to_store+="description/#{file_name}"
					add_new_content(location_to_store, local_file_path)

				when ".html"

					location_to_store+="html/#{file_name}"
					add_new_content(location_to_store, local_file_path)

				else 
					puts "Invalid file: #{File.basename(local_file_path)}"	
				end

			end	
			


			# upload course material
			
			#Course.create(name: "Microbiology", description: "Teach me how to Microbiology. Everybody Microbiology. I Microbiology real smooth.", image_lg: "", image_sm: "")

		end

		# initiates connection to Amazon S3
		def connect_s3
			if(@s3.nil?)
				@s3 = AWS::S3.new(access_key_id: S3_CONFIG[Rails.env]["s3_key"], secret_access_key: S3_CONFIG[Rails.env]["s3_secret"])
				@medectomy_bucket = @s3.buckets[S3_CONFIG[Rails.env]["s3_bucket"]]
			end
		end

		# closes connection to Amazon S3
		def disconnect_s3
			@s3 = nil
			@medectomy_bucket = nil
		end

		def add_new_content(location_to_store, local_file_path)

			s3_file = @medectomy_bucket.objects[location_to_store]

			if(s3_file.exists?)
				STDOUT.puts "File already exists: #{location_to_store}, would you like to overwrite this?"
				answer = STDIN.gets.chomp.strip
				# overwrite file
				if answer == "y" || answer == "yes"
					s3_file.write(Pathname.new(local_file_path))
					puts "Overwrote: #{location_to_store}"
				# skip file	
				else
					puts "Skipped file #{location_to_store}"	
				end
				
			else
				@medectomy_bucket.objects.create(location_to_store,Pathname.new(local_file_path))
				puts "Stored: #{location_to_store}"
			end

		end
	end

else
	puts "'Development.rake' should only be run in the development environment."
end



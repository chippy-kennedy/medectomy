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
			logger = File.open("#{Rails.root}/log/s3log.txt","a")
			Dir.glob(S3_CONFIG[Rails.env]["content_directory"]).each do |local_file_path|

				file_name = File.basename(local_file_path)

				#Extracts name of the course from the file
				course_name = file_name.split("_")[0]
				#Extracts the chapter name from the file
				chapter_name = file_name.split("_")[1].split("\#")[0]
				s3_destination = "Courses/#{course_name}/#{chapter_name}/"
				logger = File.open("#{Rails.root}/log/s3log.txt","a")
				valid = true
				puts file_name
				case File.extname(local_file_path)

				when ".png"

					if file_name.include?("#lg")
						s3_destination+="images/large/#{file_name}"
						add_new_content(s3_destination, local_file_path,logger)
					elsif file_name.include?("#sm")
						s3_destination+="images/small/#{file_name}"
						add_new_content(s3_destination, local_file_path,logger)
					elsif file_name.include?("#csm")
						s3_destination="Courses/#{course_name}/images/small/#{file_name}"
						add_new_content(s3_destination, local_file_path,logger)
					elsif file_name.include?("#clg")
						s3_destinatione="Courses/#{course_name}/images/large/#{file_name}"
						add_new_content(s3_destination, local_file_path,logger)
					else
						puts "Invalid file: #{File.basename(local_file_path)}"	
					end

				when ".txt"
					if file_name.include?('#cdesc')
						s3_destination="Courses/#{course_name}/description/#{file_name}"
						add_new_content(s3_destination, local_file_path,logger)
					elsif file_name.include?('#desc')
						s3_destination+="description/#{file_name}"
						add_new_content(s3_destination, local_file_path,logger)
					else
						puts "Invalid file: #{File.basename(local_file_path)}"	
					end
				when ".html"

					s3_destination+="html/#{file_name}"
					add_new_content(s3_destination, local_file_path,logger)

				else 
					puts "Invalid file: #{File.basename(local_file_path)}"	
				end
			end	
			


			# upload course material
			
			#Course.create(name: "Microbiology", description: "Teach me how to Microbiology. Everybody Microbiology. I Microbiology real smooth.", image_lg: "", image_sm: "")

		end
		task :add_database_info => :environment do 
			#put code to deal with finding last update
			connect_s3
			courses_tree = @medectomy_bucket.as_tree(prefix: 'Courses/')
			directories = courses_tree.children.select(&:branch?).collect(&:prefix)
			logger = File.open("#{Rails.root}/log/s3log.txt","r")
			course_names = Array.new
			new_content = Array.new
			directories.each do |f|
			course_names.push(f.split('/')[1])
			end

				line = logger.readlines.each do |line|
				break if(line.include?('Index'))
				new_content.push(line.split(':')[1].strip)
			end




			course_names.each do |course|
				course_mat = new_content.delete_if { |v| v.include?(course) }
				puts course_mat
				puts " "
				chapter_name = course_mat[0].split('/')[2]
				chapter_mat = course_mat.delete_if { |v| v.include?(chapter_name)}
				puts chapter_mat
			end


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

		def add_new_content(s3_destination, local_file_path,logger)

			s3_file = @medectomy_bucket.objects[s3_destination]

			if(s3_file.exists?)
				puts "File already exists: #{s3_destination}, would you like to overwrite this?"
				answer = STDIN.gets.chomp.strip
				# overwrite file
				if answer == "y" || answer == "yes"
					s3_file.write(Pathname.new(local_file_path))
					logger.puts("Overwrote: #{s3_destination}")
				# skip file	
				else
					puts "Skipped file #{s3_destination}"	
				end

			else
				@medectomy_bucket.objects.create(s3_destination,Pathname.new(local_file_path))
				logger.puts("Stored: #{s3_destination}")
			end

		end
	end

else
	puts "'Development.rake' should only be run in the development environment."
end



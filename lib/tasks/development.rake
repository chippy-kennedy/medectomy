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
			Base.disconnect!
			puts "Cleaned Database and S3"
		end

		task :setup => :environment do 

			connect_s3
			medectomy_bucket = Bucket.find('medectomy')

			# create course folder and chapter folder within
			S3Object.store("Courses/CourseName/Chapter/", "", "medectomy")

			Base.disconnect!

		end

		task :add_content => :environment do 

			connect_s3			

			Dir.glob(S3_CONFIG[Rails.env]["content_directory"]).each do |file|

				file_name = File.basename(file)

				#Extracts name of the course from the file
				course_name = file_name.split("_")[0]
				#Extracts the chapter name from the file
				chapter_name = file_name.split("_")[1].split("\#")[0]
				s3_path = "Courses/#{course_name}/#{chapter_name}/"
				case File.extname(file)

				when ".png"

					if file_name.include?("#lg")
						s3_path+="Large_Images/#{file_name}"
						add_new_content(s3_path,file, "medectomy")
					elsif file_name.include?("#sm")
						s3_path+="Small_Images/#{file_name}"
						add_new_content(s3_path,file, "medectomy")
					end

				when ".txt"
					s3_path+="Description/#{file_name}"
					add_new_content(s3_path,file,"medectomy")
				when ".html"
					s3_path+="HTML/#{file_name}"
					add_new_content(s3_path,file,"medectomy")
				else 
					puts "Invalid file: #{File.basename(file)}"	
				end

			end	
			Base.disconnect!

			# upload course material
			
			#Course.create(name: "Microbiology", description: "Teach me how to Microbiology. Everybody Microbiology. I Microbiology real smooth.", image_lg: "", image_sm: "")

		end

		task :overwrite_content => :environment do 

			connect_s3			

			Dir.glob(S3_CONFIG[Rails.env]["overwrite_directory"]).each do |file|

				file_name = File.basename(file)

				#Extracts name of the course from the file
				course_name = file_name.split("_")[0]
				#Extracts the chapter name from the file
				chapter_name = file_name.split("_")[1].split("\#")[0]
				s3_path = "Courses/#{course_name}/#{chapter_name}/"
				case File.extname(file)

				when ".png"

					if file_name.include?("#lg")
						s3_path+="Large_Images/#{file_name}"
						overwrite_content(s3_path,file, "medectomy")
					elsif file_name.include?("#sm")
						s3_path+="Small_Images/#{file_name}"
						overwrite_content(s3_path,file, "medectomy")
					end

				when ".txt"
					s3_path+="Description/#{file_name}"
					overwrite_content(s3_path,file,"medectomy")
				when ".html"
					s3_path+="HTML/#{file_name}"
					overwrite_content(s3_path,file,"medectomy")
				else 
					puts "Invalid file: #{File.basename(file)}"	
				end

			end	
			Base.disconnect!

			# upload course material
			
			#Course.create(name: "Microbiology", description: "Teach me how to Microbiology. Everybody Microbiology. I Microbiology real smooth.", image_lg: "", image_sm: "")

		end

		# initiates connection to Amazon S3
		def connect_s3
			if(!Base.connected?)
				Base.establish_connection!(
					access_key_id: S3_CONFIG[Rails.env]["s3_key"], 
					secret_access_key: S3_CONFIG[Rails.env]["s3_secret"]
					)
			end
		end
		def add_new_content(s3_path,file, bucket)
			if(S3Object.exists? s3_path, bucket)
				puts "File already exists: #{s3_path}"
				puts "Use dev:overwrite_content to overwrite files"
			else
				S3Object.store(s3_path,open(file), bucket)
				puts "Stored: #{s3_path}"
			end

		end

		def overwrite_content(s3_path,file, bucket)
			if(S3Object.exists? s3_path, bucket)
				S3Object.delete s3_path, bucket
				S3Object.store(s3_path,open(file),bucket)
				puts "Overwrote: #{s3_path}"
			else
				puts "File does not exist: #{s3_path}"
				puts "Use dev:add_content to create new content"
			end

		end
	end

else

	puts "'Development.rake' should only be run in the development environment."

end












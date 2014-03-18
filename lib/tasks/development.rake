# Rake task to generate testing data for use in the development environment

require 'faker'
require 'ext/faker'
require 'database_cleaner'
require 'fileutils'

#include AWS::S3
 
	namespace :dev do

		# holds an AWS S3 object
		@s3 = nil
		@medectomy_bucket = nil
		askAgain = false;
		
		desc "cleans development files & deletes all files from medectomy S3"
		task :clean => :environment do

			# clean the database
      DatabaseCleaner.strategy = :truncation, {:only => %w[chapters courses enrollments]}
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
			@medectomy_bucket.objects.create(Pathname.new("courses/"), "")
			puts "Created course directory"

			disconnect_s3

		end
		desc "Cleans, uploads, organizes, and structures html all in one"
		task :redo => :environment  do
			Rake::Task['dev:clean'].invoke
			Rake::Task['dev:add_content'].invoke
			Rake::Task['dev:organize_information'].invoke
			Rake::Task['dev:structure_html'].invoke
			Rake::Task['dev:add_database_info'].invoke
		end
		task :add_content => :environment do 

			connect_s3			
			logger = File.open("#{Rails.root}/log/s3log.txt","a")
			content_directory = YAML.load(ERB.new(File.read("#{Rails.root}/config/aws.yml")).result)[Rails.env]["content_directory"]
			new_content = Dir.glob(content_directory)
			puts content_directory

			new_content.each do |local_file_path|
				file_name = File.basename(local_file_path)

				#Extracts name of the course from the file
				course_name = file_name.split("_")[0]
				#Extracts the chapter name from the file
				chapter_name = file_name.split("_")[1].split("\#")[0]
				s3_destination = "courses/#{course_name}/#{chapter_name}/"
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
						s3_destination="courses/#{course_name}/information/images/small/#{file_name}"
						add_new_content(s3_destination, local_file_path,logger)
					elsif file_name.include?("#clg")
						s3_destination="courses/#{course_name}/information/images/large/#{file_name}"
						add_new_content(s3_destination, local_file_path,logger)
					elsif file_name.include?("#him")
						s3_destination+="html/images/#{file_name}"
						add_new_content(s3_destination, local_file_path,logger)
					else
						puts "Invalid file: #{File.basename(local_file_path)}"	
					end

				when ".txt"
					if file_name.include?('#cdesc')
						s3_destination="courses/#{course_name}/information/description/#{file_name}"
						add_new_content(s3_destination, local_file_path,logger)
					elsif file_name.include?('#desc')
						s3_destination+="description/#{file_name}"
						add_new_content(s3_destination, local_file_path,logger)
					else
						puts "Invalid file: #{File.basename(local_file_path)}"	
					end
				when ".html"

					s3_destination+="html/#{file_name}.erb"
					add_new_html(s3_destination, local_file_path,logger)

				else 
					puts "Invalid file: #{File.basename(local_file_path)}"	
				end
			end	
			


			# upload course material
			
			#Course.create(name: "Microbiology", description: "Teach me how to Microbiology. Everybody Microbiology. I Microbiology real smooth.", image_lg: "", image_sm: "")

		end
		desc "Creates a directory structure from the files uploaded"
		task :organize_information => :environment do		
			logger = File.open("#{Rails.root}/log/s3log.txt","a")
			Dir.glob(YAML.load(ERB.new(File.read("#{Rails.root}/config/aws.yml")).result)[Rails.env]["content_directory"]).each do |local_file_path|

				file_name = File.basename(local_file_path)

				#Extracts name of the course from the file
				course_name = file_name.split("_")[0]
				#Extracts the chapter name from the file
				chapter_name = file_name.split("_")[1].split("\#")[0]
        FileUtils.rm_rf "#{Rails.root}/resources/struture"
         FileUtils.rm_rf "#{Rails.root}/resources/struture"
				s3_destination = "#{Rails.root}/resources/structure/courses/#{course_name}/#{chapter_name}/"
        valid = true
				case File.extname(local_file_path)

				when ".png"

					if file_name.include?("#lg")
						s3_destination+="images/large"
						organize(s3_destination, local_file_path)
					elsif file_name.include?("#sm")
						s3_destination+="images/small"
						organize(s3_destination, local_file_path)
					elsif file_name.include?("#csm")
						s3_destination="#{Rails.root}/resources/structure/courses/#{course_name}/information/images/small"
						organize(s3_destination, local_file_path)
					elsif file_name.include?("#clg")
						s3_destination="#{Rails.root}/resources/structure/courses/#{course_name}/information/images/large"
						organize(s3_destination, local_file_path)
					elsif file_name.include?("#him")
						s3_destination+="html/images"
						organize(s3_destination,local_file_path)
					else
						puts "Invalid file: #{File.basename(local_file_path)}"	
					end

				when ".txt"
					if file_name.include?('#cdesc')
						s3_destination="#{Rails.root}/resources/structure/courses/#{course_name}/information/description"
						organize(s3_destination, local_file_path)
					elsif file_name.include?('#desc')
						s3_destination+="description"
						organize(s3_destination, local_file_path)
					else
						puts "Invalid file: #{File.basename(local_file_path)}"	
					end
				when ".html"

					s3_destination+="html"
					organize(s3_destination, local_file_path)
				else 
					puts "Invalid file: #{File.basename(local_file_path)}"	
				end

			end
		end
		task :add_database_info => :environment do 
			#put code to deal with finding last update
			connect_s3
			courses_tree = @medectomy_bucket.as_tree(prefix: 'courses/')
			directories = courses_tree.children.select(&:branch?).collect(&:prefix)
			logger = File.open("#{Rails.root}/log/s3log.txt","r")

			course_list = Dir["#{Rails.root}/resources/structure/courses/*"]
      course_list.map! {|c| c.split("/").last}
			course_list.each do |course_name|
    
			new_content = Array.new
			chapter_names = Set.new
				course_content = Dir["#{Rails.root}/resources/structure/courses/#{course_name}/information/**/*"]
				course_database_information = Hash.new
				course_database_information[:name] = course_name
				course_content.each do |file|
					file = file.split("/resources/structure/").last
					if(file.include?('#cdesc'))
						course_database_information[:description] = @medectomy_bucket.objects[file].read
					elsif(file.include?("#clg"))
						course_database_information[:icon_lg] = file
					elsif(file.include?("#csm"))
						course_database_information[:icon_sm] = file
					end
				end
        Course.new(course_database_information).save
    #need to count all chapter directories besides the course information folder
        chapter_names_all = Dir["#{Rails.root}/resources/structure/courses/#{course_name}/*"]
				chapter_names_all.each do |name|
					if(!name.include?("information"))
            chapter_names.add name.split("/#{course_name}/").last
					end
				end
				chapter_names.each do |chapter_name|
          @course = Course.find_by name: course_name
					chapter_database_information = Hash.new
					chapter_database_information[:name] = chapter_name.split("-").last
					chapter_database_information[:number] = chapter_name.split("-").first
					chapter_database_information[:course_id] = @course.id
					chapter_content = Dir["#{Rails.root}/resources/structure/courses/#{course_name}/#{chapter_name}/**/*"]
					chapter_content.each do |file|
						file = file.split("/resources/structure/").last
						if(file.include?('#desc'))
							chapter_database_information[:description] = @medectomy_bucket.objects[file].read
						elsif(file.include?("#lg"))
							chapter_database_information[:icon_lg] = file
						elsif(file.include?("#sm"))
							chapter_database_information[:icon_sm] = file
						elsif(file.include?(".html"))
							chapter_database_information[:directory] = file + '.erb'
						end
					end
          
          Chapter.new(chapter_database_information).save
				end
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

		def organize(s3_destination,local_file_path)
			puts s3_destination
			FileUtils.mkpath(s3_destination)
			FileUtils.cp local_file_path, s3_destination
			puts "Organized: #{s3_destination} #{local_file_path}"
		end

		def add_new_html(s3_destination, local_file_path,logger)

			s3_file = @medectomy_bucket.objects[s3_destination]

			if(s3_file.exists?)
				puts "File already exists: #{s3_destination}, would you like to overwrite this?"
				answer = STDIN.gets.chomp.strip
				# overwrite file
				if answer == "y" || answer == "yes"

					s3_file.write(Pathname.new(local_file_path))
					html = s3_file.read
					nicehtml = Nokogiri::HTML(html).to_html
					s3_file.write(nicehtml)
					logger.puts("Overwrote: #{s3_destination}")
				# skip file	
			else
				puts "Skipped file #{s3_destination}"	
			end

		else
			@medectomy_bucket.objects.create(s3_destination,Pathname.new(local_file_path))
			s3_file = @medectomy_bucket.objects[s3_destination]
			html = s3_file.read
			nicehtml = Nokogiri::HTML(html).to_html
			s3_file.write(nicehtml)
			logger.puts("Stored: #{s3_destination}")
		end

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

# Rake task to generate testing data for use in the development environment

require 'faker'
require 'ext/faker'
require 'database_cleaner'
require 'fileutils'


	namespace :dev do

		# holds an AWS S3 object
		@s3 = nil
		@medectomy_bucket = nil
		askAgain = false;
		
  desc "cleans development files & deletes all files from medectomy S3"
  task :clean => :environment do
    # clean the database
    DatabaseCleaner.strategy = :truncation, {:only => %w[chapters courses]}
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

  task :structure_html => :environment do
    #put code to deal with finding last update
    connect_s3

    courses_tree = @medectomy_bucket.as_tree(prefix: 'courses/')
    directories = courses_tree.children.select(&:branch?).collect(&:prefix)
    course_names = Set.new
    new_content = Array.new
    chapter_names = Set.new

    course_list = Dir["#{Rails.root}/resources/structure/courses/*"]

    course_list.each do |course_name|
      course_name.slice!("#{Rails.root}/resources/structure/courses/")
      course_names.add course_name
      course_names.each do |file|

        #need to count all chapter directories besides the course information folder
        chapter_names_all = Dir["#{Rails.root}/resources/structure/courses/#{file}/*"]
        chapter_names_all.each do |name|
          if(!name.include?("information"))
            chapter_names.add name.split("/#{file}/").last
          end
        end
        chapter_names.each do |chapter_name|
          html_files= Dir["#{Rails.root}/resources/structure/courses/#{course_name}/#{chapter_name}/**/*.html"]
          images =  Dir["#{Rails.root}/resources/structure/courses/#{course_name}/#{chapter_name}/html/images/**/*"]
          html_files.each do |file|
            file = file.split("/resources/structure/").last
            @htmlFile = @medectomy_bucket.objects[file +".erb"]
            html_string = @htmlFile.read
            htmlDoc = Nokogiri::HTML(html_string)
            img_tags = htmlDoc.css('img')
            #oldtag = nil
            img_tags.each do |img_tag|
              old_url = img_tag.to_s
              img_name = img_tag.attribute('src').value.split("_").last
              # uses the directory structure to get the key for the image in s3
              s3_image_key = Dir["#{Rails.root}/resources/structure/courses/#{course_name}/#{chapter_name}/html/images/**/*#{img_name}"][0].split("/resources/structure/").last
              ruby = "<%begin%><%@s3=AWS::S3.new(access_key_id:S3_CONFIG[Rails.env][\"s3_key\"],secret_access_key:S3_CONFIG[Rails.env][\"s3_secret\"])%><%@medectomy_bucket=@s3.buckets[S3_CONFIG[Rails.env][\"s3_bucket\"]]%><%=image_tag(@medectomy_bucket.objects[\"#{s3_image_key}\"].url_for(:read).to_s)%><%@medectomy_bucket = nil%> <%@s3=nil%><%end%>"
              reg = Regexp.new(Regexp.escape(old_url))
              html_string = html_string.gsub(reg,ruby)
            end
            reg = Regexp.new(".*<head>.*</head>",Regexp::MULTILINE) 
           html_string = html_string.gsub(reg,"")
           reg = Regexp.new("</body>.*</html>",Regexp::MULTILINE)
           html_string= html_string.gsub(reg,"")
						@htmlFile.write(html_string)
          end
        end
      end
    end
  end
    

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

class ChaptersController < ApplicationController
	
	skip_authorization_check

	def index
		render "chapters/index"
	end

	def show
		@course = Course.find(params[:id])
		@chapter = Chapter.find(params[:id])

		# pull content from s3
		@s3 = AWS::S3.new(access_key_id: S3_CONFIG[Rails.env]["s3_key"], secret_access_key: S3_CONFIG[Rails.env]["s3_secret"])
		@medectomy_bucket = @s3.buckets[S3_CONFIG[Rails.env]["s3_bucket"]] 
		@file = @medectomy_bucket.objects[@chapter.directory].read

		render "/chapters/show"
	end

	def new
		@chapter = chapter.new
	end

	def create
		@chapter = chapter.create(permitted_params.chapter)

		if @chapter.save
			puts "chapter: #{@chapter.name} created successfully."
		else
			puts "chapter: #{@chapter.name} creation failed."
		end

	end

	def edit 
		@chapter = chapter.find(params[:id])
	end

	def update
		@chapter = chapter.find(params[:id])

  		if @chapter.update_attributes(permitted_params.chapter)
  			puts "chapter: #{@chapter.name} updated successfully."
  		else
  			puts "chapter: #{@chapter.name} updated failed."
  		end
    
	end

	def destroy
    	
    	@chapter = chapter.find(params[:id])
    	@chapter.destroy

    	puts "Destroyed: #{@chapter.name} chapter."
  	end


end

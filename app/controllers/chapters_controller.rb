class ChaptersController < ApplicationController
	
	skip_authorization_check

	def index
		@test = true
		render "chapters/index"
	end

	def show
		@Course = Course.find(params[:id])
		@Chapter = Chapter.find(params[:id])
		render "/courses/:course_id/chapters/:id"
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

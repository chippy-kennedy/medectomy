class CoursesController < ApplicationController
  
  skip_authorization_check
  
	def index
   		@courses = Course.all
		render "courses/index"
	end

	def show
		@course = Course.find(params[:id])
	end

	def new
		@course = Course.new
	end


	def create
		@course = Course.create(permitted_params.course)

		if @course.save
			puts "Course: #{@course.name} created successfully."
		else
			puts "Course: #{@course.name} creation failed."
		end

	end


	def edit 
		@course = course.find(params[:id])
	end

	def update
		@course = course.find(params[:id])

  		if @course.update_attributes(permitted_params.course)
  			puts "Course: #{@course.name} updated successfully."
  		else
  			puts "Course: #{@course.name} updated failed."
  		end
    
	end

	def destroy
    	
    	@course = course.find(params[:id])
    	@course.destroy

    	puts "Destroyed: #{@course.name} course."
  	end
end


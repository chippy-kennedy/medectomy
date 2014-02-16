class CoursesController < ApplicationController


	#TODO: Fix below is the only way to run the program and access this controller
	#without an AuthroizationNotPerformedError
	skip_authorization_check

	def index
		render "courses/index"
	end


	#TODO: I am not apt enought at testing,
	#so I cannot call on specific objects because the databases are empty
	def show
		#@Course = Course.find(params[:id])
		render "courses/chapter-list"
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


#TODO: should 'courses' be capitalized below???

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

#TODO: THIS (BELOW) IS NOT BEING USED AS OF YET

class ChaptersController < CoursesController

	def show
		@Course = Course.find(params[:id])
		@Chapter = Chapter.find(params[:id])
		render "/courses/:course_id/chapters/:id"
	end

end

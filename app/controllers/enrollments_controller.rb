class EnrollmentsController < ApplicationController
  	load_and_authorize_resource

	def index
		@courses = current_student.courses
	end

	def create
		@enrollment = Enrollment.create(course_id: params[:course_id], user_id: current_user.id)

		respond_to do |format|
	    	format.html { redirect_to courses_path }
	    	format.js
	  	end
	end
	
end
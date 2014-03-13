class EnrollmentsController < ApplicationController
  	#load_and_authorize_resource
  	skip_authorization_check

	def index
		@courses = current_student.courses
	end

	def create
		@enrollment = Enrollment.create(course_id: params[:course_id], user_id: current_user.id)
		respond_to do |format|
	    	format.js
	  	end
	end

	def destroy
		debugger
		@enrollment = Enrollment.find(params[:enrollment_id]).destroy
		respond_to do |format|
	    	format.js
	  	end
	end
	
end
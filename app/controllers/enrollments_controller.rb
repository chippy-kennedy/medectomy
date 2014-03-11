class EnrollmentsController < Application EnrollmentsController
  
	def index
		@courses = current_student.courses
	end
	
end
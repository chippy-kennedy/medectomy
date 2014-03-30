module EnrollmentsHelper

	def enrolled_in?(course, user)
		return Enrollment.where(user_id: user.id, course_id: course.id).count > 0
	end

	def get_enrollment(course, user)
		Enrollment.where(user_id: user.id, course_id: course.id).first
	end
end

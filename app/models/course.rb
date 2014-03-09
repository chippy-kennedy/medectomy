class Course < ActiveRecord::Base

	has_many :users, through: :enrollments
	has_many :chapters

end

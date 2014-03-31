class Enrollment < ActiveRecord::Base

	belongs_to :user
	belongs_to :course
  
  validates_uniqueness_of :course, :scope => :user

end

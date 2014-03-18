class Chapter < ActiveRecord::Base
	belongs_to :course
  
  # ensures that chapter number and name is unique within a course
  validates_uniqueness_of :course_id, :scope => [:number, :name]

end

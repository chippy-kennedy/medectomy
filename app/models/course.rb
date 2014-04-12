class Course < ActiveRecord::Base

	belongs_to :section

	has_many :enrollments, :dependent => :destroy
	has_many :users, through: :enrollments
	has_many :chapters

	#ensures that course number and name is unique within a section
  	validates_uniqueness_of :section_id, :scope => [:number, :name]

end

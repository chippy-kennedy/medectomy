class Course < ActiveRecord::Base
	attr_accessible :name, :description, :icon_lg, :icon_sm
	has_many :chapters
end

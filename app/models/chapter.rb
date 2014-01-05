class Chapter < ActiveRecord::Base
	attr_accessible :name, :number, :directory, :icon_lg, :icon_sm
	belongs_to :course

	validates :number, uniqueness:true
end

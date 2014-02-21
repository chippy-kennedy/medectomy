class Chapter < ActiveRecord::Base
	belongs_to :course
	validates :number, uniqueness:true



end

class Note < ActiveRecord::Base
	belongs_to :dashboard
	validates :number, uniqueness:true

	def index

	end

	def show
		@Note = Note.find(params[:id])
		
end



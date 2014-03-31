class SectionsController < ApplicationController
  
  skip_authorization_check
  
	def index
   		@sections = Section.all
		render "sections/index"
	end

	def show
		@section = Section.find(params[:id])
	end

	def new
		@section = Section.new
	end


	def create
		@section = Section.create(permitted_params.section)

		if @section.save
			puts "Section: #{@section.name} created successfully."
		else
			puts "Section: #{@section.name} creation failed."
		end

	end


	def edit 
		@section = section.find(params[:id])
	end

	def update
		@section = section.find(params[:id])

  		if @section.update_attributes(permitted_params.section)
  			puts "Section: #{@section.name} updated successfully."
  		else
  			puts "Section: #{@section.name} updated failed."
  		end
    
	end

	def destroy
    	
    	@section = section.find(params[:id])
    	@section.destroy

    	puts "Destroyed: #{@section.name} section."
  	end
end


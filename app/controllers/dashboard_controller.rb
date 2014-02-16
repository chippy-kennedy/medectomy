class DashboardController < ApplicationController

	#TODO: Fix below is the only way to run the program and access this controller
	#without an AuthroizationNotPerformedError
	skip_authorization_check

	def index
		
	end

	def show
		#TODO: TESTING NEEDED FOR BELOW
		#@Course = Course.find(params[:id])
		#@Chapter = Chapter.find(params[:id])
		render "dashboard/workspace"
	end


	#Shows the Contact Us Page
	def contact
		render "dashboard/contact"
	end

end
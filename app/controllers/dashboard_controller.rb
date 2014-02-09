class DashboardController < ApplicationController

	#TODO: Fix below is the only way to run the program and access this controller
	#without an AuthroizationNotPerformedError
	skip_authorization_check

	def index
		
	end

end
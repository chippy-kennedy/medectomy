class UsersController < ApplicationController
	
	skip_authorization_check

	def index
    @enrollments = current_user.enrollments
		render 'users/index'
	end

end
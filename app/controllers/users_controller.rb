class UsersController < ApplicationController
	
	skip_authorization_check

	def index
		render 'users/index'
	end

end
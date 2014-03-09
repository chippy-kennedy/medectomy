class PagesController < ApplicationController

	skip_authorization_check

	def home
		render "pages/home"
	end

end

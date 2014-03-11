class PagesController < ApplicationController

	skip_authorization_check
  skip_before_filter :authenticate_user!

	def home
		render "pages/home"
	end

end

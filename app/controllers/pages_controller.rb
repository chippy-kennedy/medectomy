class PagesController < ApplicationController

	skip_authorization_check
  skip_before_filter :authenticate_user!

	def home
		render "pages/home"
	end

	def available_courses
		render "pages/available_courses"
	end

end

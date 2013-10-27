class PrelaunchController < ActionController::Base
	protect_from_forgery with: :exception

	def index
		render "prelaunch/index"
	end

end
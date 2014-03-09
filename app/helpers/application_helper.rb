module ApplicationHelper

	# returns true if the current page should have a left sidebar
	def has_left_sidebar?
		if params[:controller] == "chapters"
			return true
		end
		false
	end

end

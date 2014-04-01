module ApplicationHelper
	
	# returns true if the current page should have a left sidebar
	def has_left_sidebar?
		if params[:controller] == "chapters" || (params[:controller] == "courses" && params[:action] == "show")
			return true
		end
		false
	end

end

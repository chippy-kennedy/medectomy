module ApplicationHelper

	# returns true if the current page should have a left sidebar
	def has_left_sidebar?
		
		if current_page?(controller:"chapters", action: "index")
			return true
		end

		false
	end

end

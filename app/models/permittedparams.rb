class PermittedParams < Struct.new(:params, :user)

def course
	params.require(:course).permit(*course_attributes)
end

def course_attributes
	if user_signed_in?
		if current_user.has_role? :admin
			[:name, :description, :icon_lg, :icon_sm]
		end
	end
end

def chapter
	params.require(:chapter).permit(*chapter_attributes)
end

def chapter_attributes
	if user_signed_in?
		if current_user.has_role? :admin
			[:name, :number, :directory, :icon_lg, :icon_sm]
		end
	end
end


end


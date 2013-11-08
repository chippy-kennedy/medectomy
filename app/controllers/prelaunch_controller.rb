class PrelaunchController < ApplicationController
	protect_from_forgery with: :exception
	
	layout 'prelaunch'

	def index
		@subscriber = Subscriber.new
		render "prelaunch/index"
	end
    
    def contact
        render "prelaunch/contact"
    end
    

	def subscribe
		# add validation code here
		# initiate new instance of gibbon api
		gibbon = Gibbon::API.new
		# add user to the mailing list
		gibbon.lists.subscribe({:id => '6820f3a4e0', :email => {:email => params[:email]}, :double_optin => false})

		redirect_to :root
	end

end
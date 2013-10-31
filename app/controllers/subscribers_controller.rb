class SubscribersController < ApplicationController 

	def create
# initiate new instance of gibbon api
		gibbon = Gibbon::API.new
		# add user to the mailing list
		gibbon.lists.subscribe({:id => '6820f3a4e0', :email => {:email => params[:email]}, :double_optin => false})

		
		redirect to: root
	end

end


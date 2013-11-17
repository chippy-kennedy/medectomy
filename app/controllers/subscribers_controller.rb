class SubscribersController < ApplicationController 

	def create
		debugger
		# add entry to database
		subscriber = Subscriber.create(params[:subscriber].permit(:first_name, :last_name, :email_primary, :email_secondary, :current_level))
		if subscriber.valid?
			# initiate new instance of gibbon api
			gibbon = Gibbon::API.new
			# add user to the mailing list
			gibbon.lists.subscribe({:id => '6820f3a4e0', :email => {:email => params[:subscriber][:email_primary]}, :double_optin => false})

			respond_to do |format|
				flash[:notice] = "Thank you for subscribing to Medectomy."
				format.html {redirect_to root_path}
				format.js 
			end
		else
			respond_to do |format|
				flash[:error] = subscriber.errors.full_messages.to_sentence
				format.html {redirect_to root_path}
				format.js 
			end
		end

	end
end


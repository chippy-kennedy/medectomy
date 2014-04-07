class RegistrationsController < Devise::RegistrationsController

private

def account_update_params
	params.require(:user).permit(:first_name,:last_name,:email, :graduation_year,:degree,:description,:twitter_handle,:facebook_id,:linkedin_id,:password)
end

def sign_up_params
	params.require(:user).permit(:first_name,:last_name,:email, :graduation_year,:degree)
end
end
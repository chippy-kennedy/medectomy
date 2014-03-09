class User < ActiveRecord::Base

	has_many :enrollments
	has_many :courses, through: :enrollments

	rolify
	# Include default devise modules. Others available are:
	# :token_authenticatable, :confirmable,
	# :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	     :recoverable, :rememberable, :trackable, :validatable

	def has_image?
		false
	end

end

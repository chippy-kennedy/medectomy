class User < ActiveRecord::Base

	rolify

	has_many :enrollments, :dependent => :destroy
	has_many :courses, through: :enrollments
	belongs_to :university

	before_create :detect_university
	after_create :assign_role

	# Include default devise modules. Others available are:
	# :token_authenticatable, :confirmable,
	# :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	     :recoverable, :rememberable, :trackable, :validatable

	def has_image?
		false
	end

	# add a role to the newly created user
	def assign_role
		self.add_role :student
	end

	# create user's university affiliation via their email address
	def detect_university
		# try to find a matching domain
		domain = Domain.where(name: self.email.split("@").last).first

		if domain.nil?
			#TODO: the two lines below were keeping the rake tasks from working properly
			flash[:notice] = "Your institution does not currently have access to Medectomy. Feel free to contact us for a personal account."
			redirect_to root
		else
			self.university_id = domain.university_id
		end
	end
end

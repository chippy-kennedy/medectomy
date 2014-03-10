class University < ActiveRecord::Base
	has_many :domains
	has_many :users
end

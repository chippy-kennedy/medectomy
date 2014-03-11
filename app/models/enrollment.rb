class Enrollment < ActiveRecord::Base

  belongs_to :user, :dependent => :destroy
	belongs_to :course, :dependent => :destroy
  
  validates_uniqueness_of :course, :scope => :user

end

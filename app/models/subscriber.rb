class EmailValidator < ActiveModel::EachValidator
  def validate(record)
    unless record.email_primary =~ /^[A-Z0-9._%+]+@[A-Z0-9.]+\.[A-Z]{2,6}$/i
      record.errors[:email_primary] << (options[:message] || "is not an email")
    end

    if !contains_university_email(record)
    	record.errors.add(:base, "Either primary or secondary email must be a university email")
    end

  end

  private 

  def contains_university_email(record)
  	if (record.email_primary =~ /^[A-Z0-9._%+]+@[A-Z0-9.]+\.edu$/i) || (record.email_secondary =~ /^[A-Z0-9._%+]+@[A-Z0-9.]+\.edu$/i)
  		return true
  	end
  end

end

class Subscriber < ActiveRecord::Base
	include ActiveModel::Validations
	validates :first_name, :last_name, :email_primary, :current_level, presence: true
	validates :email_primary, :email_secondary, uniqueness: true, email:true

end


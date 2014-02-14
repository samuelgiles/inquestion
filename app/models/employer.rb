class Employer < ActiveRecord::Base

	has_many :apprentices, :class_name => "User", :foreign_key => "employer_id"

end

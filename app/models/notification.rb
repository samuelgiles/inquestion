class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  
  scope :unseen, lambda { where(seen: nil) }

end

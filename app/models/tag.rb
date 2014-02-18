class Tag < ActiveRecord::Base
  belongs_to :user
  has_many :subscribed_users, :foreign_key => 'user_id', :class_name => "User", :through => :notifytags, :source => :user
  has_many :notifytags
end

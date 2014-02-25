class Tag < ActiveRecord::Base

	extend FriendlyId
	friendly_id :title, use: [:slugged, :finders]
	
	belongs_to :user
	has_many :subscribed_users, :foreign_key => 'user_id', :class_name => "User", :through => :notifytags, :source => :user
	has_many :notifytags

	before_save { |tag| tag.title = tag.title.downcase }

end

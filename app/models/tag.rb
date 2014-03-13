class Tag < ActiveRecord::Base

	extend FriendlyId
	friendly_id :title, use: [:slugged, :finders]
	
	belongs_to :user
	has_many :subscribed_users, :foreign_key => 'user_id', :class_name => "User", :through => :notifytags, :source => :user
	has_many :notifytags

	def title=(val)
		write_attribute(:title, Tag.sanitize_title(val))
	end

	include PgSearch
	pg_search_scope :search, :against => {
    :title => 'A'
  	}, :using => { :trigram => { :threshold => 0.1 } }

  	def self.sanitize_title(val)
  		val.strip.downcase.gsub("#", "")
  	end

end

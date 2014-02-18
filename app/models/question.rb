class Question < ActiveRecord::Base
	include Rails.application.routes.url_helpers

	belongs_to :user
	has_many :answers
	belongs_to :accepted_answer, :class_name => "Answer", :foreign_key => :answer_id

	has_many :questiontags
	has_many :tags, through: :questiontags
	has_many :votes

	validates :title, :presence => true
  	validates :content, :presence => true
  	validates :user, :presence => true

	scope :unanswered, lambda { where(answer_id: nil) }
	scope :answered, lambda { joins(:answers).where("answers.id = questions.answer_id") }

	def tag_list
		tags.map(&:title).join(", ")
	end

	def tag_list=(titles)
		self.tags = titles.split(",").map do |n|
    		Tag.where(title: n.strip).first_or_create do |t|
    			t.user = self.user
    		end 
  		end

  		self.tags.each do |ta|
  			if ta.count == nil
  				ta.count = 1
  			else
  				ta.count += 1
  			end
  			ta.save
  		end
	end

	def answered

		return self.accepted_answer != nil

	end

	#Notifies any users that are in the tags of the new question
	#Also notifies the users assessor of the new question
	after_create :create_new_question_notification
	def create_new_question_notification

		if self.user.assessor_students.present? 
			self.user.assessor.notifications.create(:content => "has posted a question \"#{self.title}\" (you are their assessor)", :author => self.user, :link => question_path(:id => self.id))
		end

		#build a list of users to send notification to:
		notify_users = []
		self.tags.each do |tag|
			notify_users.concat(tag.subscribed_users.where.not(id: self.user.id).select(:user_id).collect{|u| u.user_id})
		end
		notify_users = notify_users.uniq

		notify_users.each do |u|
			@user = User.where(:id => u).first
			@user.notifications.create(:content => "has posted a question \"#{self.title}\" with the tags \"#{self.tag_list}\"", :author => self.user, :link => question_path(:id => self.id))
		end

	end

end

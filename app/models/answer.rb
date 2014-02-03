class Answer < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  belongs_to :question
  belongs_to :user
  has_many :answer_votes

  def votecount

  	self.answer_votes.count

  end

  after_create :create_new_answer_notification
  def create_new_answer_notification
    
  	u = self.question.user
  	u.notifications.create(:content => "has answered your question \"#{self.question.title}\"", :author => self.user, :link => question_path(:id => self.question.id))

  end

end

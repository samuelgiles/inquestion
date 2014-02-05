class AnswerVote < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  after_create :create_new_answer_vote_notification
  def create_new_answer_vote_notification
    
  	u = self.question.user
  	u.notifications.create(:content => "has voted your answer to question: \"#{self.question.title}\"", :author => self.user, :link => question_path(:id => self.question.id))

  end
end

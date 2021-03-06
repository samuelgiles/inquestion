class Answer < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  belongs_to :question, touch: true
  belongs_to :user, touch: true

  has_many :votes, :class_name => "AnswerVote"
  scope :has_vote_from, lambda {|userid| joins(:votes).where("answer_votes.user_id = ?", userid )}

  include PgSearch
  pg_search_scope :search, :against => {
  :content => 'A'
  }, :using => { :tsearch => {:prefix => true, :dictionary => "english"} }

  def votecount

  	self.votes.count

  end

  after_create :create_new_answer_notification
  def create_new_answer_notification
    
  	u = self.question.user
    if self.question.user.id != self.user.id
  	 u.notifications.create(:content => "has answered your question \"#{self.question.title}\"", :author => self.user, :link => question_path(:id => self.question.id))
    end

  end

end

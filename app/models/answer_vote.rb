class AnswerVote < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :answer, touch: true
end

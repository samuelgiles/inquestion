class AddAcceptedAnswerToQuestions < ActiveRecord::Migration
  def change
    add_reference :questions, :answer, index: true
  end
end

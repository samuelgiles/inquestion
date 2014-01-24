class CreateAnswerVotes < ActiveRecord::Migration
  def change
    create_table :answer_votes do |t|
      t.references :question, index: true
      t.references :user, index: true
      t.timestamps
    end
  end
end

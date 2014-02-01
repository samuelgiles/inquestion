class RemoveAcceptedFromAnswers < ActiveRecord::Migration
  def change
  	remove_column :answers, :accepted
  end
end

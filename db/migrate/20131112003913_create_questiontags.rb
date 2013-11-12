class CreateQuestiontags < ActiveRecord::Migration
  def change
    create_table :questiontags do |t|
      t.references :question, index: true
      t.references :tag, index: true

      t.timestamps
    end
  end
end

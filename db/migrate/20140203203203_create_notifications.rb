class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :content
      t.string :link
      t.boolean :seen
      t.references :user, index: true
      t.integer  :author_id, index: true
      t.timestamps
    end
  end
end

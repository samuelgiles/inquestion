class CreateNotifytags < ActiveRecord::Migration
  def change
    create_table :notifytags do |t|
      t.references :user, index: true
      t.references :tag, index: true

      t.timestamps
    end
  end
end

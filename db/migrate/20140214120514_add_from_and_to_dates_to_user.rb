class AddFromAndToDatesToUser < ActiveRecord::Migration
  def change
  	add_column :users, :start_date, :datetime
  	add_column :users, :end_date, :datetime
  end
end

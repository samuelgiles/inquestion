class AddCoordinatorToUser < ActiveRecord::Migration
  def change
  	add_column :users, :coordinator_user_id, :int
  end
end

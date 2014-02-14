class AddCoordinatorFlagToUser < ActiveRecord::Migration
  def change
  	add_column :users, :coordinator, :boolean
  end
end

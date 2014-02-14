class RemoveEmployerDataFromUser < ActiveRecord::Migration
  def change
  	remove_column :users, :employerName
  	remove_column :users, :employerAddress
  	remove_column :users, :employerPhone
  end
end

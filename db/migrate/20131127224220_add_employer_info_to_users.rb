class AddEmployerInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :employerName, :string
    add_column :users, :employerAddress, :string
    add_column :users, :notes, :string
  end
end

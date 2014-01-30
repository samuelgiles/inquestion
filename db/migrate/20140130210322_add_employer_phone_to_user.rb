class AddEmployerPhoneToUser < ActiveRecord::Migration
  def change
  	add_column :users, :employerPhone, :string
  end
end

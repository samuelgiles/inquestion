class AddUserinfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :forename, :string
    add_column :users, :surname, :string
    add_column :users, :age, :int
    add_column :users, :admin, :boolean
    add_column :users, :banned, :boolean
    add_column :users, :assesor_user_id, :int
  end
end

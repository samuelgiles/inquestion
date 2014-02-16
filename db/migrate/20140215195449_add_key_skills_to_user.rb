class AddKeySkillsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :english, :boolean
  	add_column :users, :maths, :boolean
  	add_column :users, :it, :boolean
  end
end

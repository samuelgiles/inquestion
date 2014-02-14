class AddEmployerToUser < ActiveRecord::Migration
  def change
  	change_table :users do |t|
  		t.references :employer, index: true
  	end
  end
end

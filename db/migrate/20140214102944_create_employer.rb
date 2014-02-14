class CreateEmployer < ActiveRecord::Migration
  def change
    create_table :employers do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.string :notes
    end
  end
end

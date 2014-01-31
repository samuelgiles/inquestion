class AddCountToTags < ActiveRecord::Migration
  def change
  	add_column :tags, :count, :int
  end
end

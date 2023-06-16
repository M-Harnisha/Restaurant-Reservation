class AddColumnInUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users , :preference , :jsonb , default:{type:[]},null: false 
  end
end

class AddColumnTableName < ActiveRecord::Migration[7.0]
  def change
    add_column :table_bookeds , :name , :string
  end
end

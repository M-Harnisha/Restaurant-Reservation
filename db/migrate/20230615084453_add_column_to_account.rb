class AddColumnToAccount < ActiveRecord::Migration[7.0]
  def change
    remove_column :users , :name , :string
    remove_column :users , :contact , :string
    remove_column :owners , :name , :string
    remove_column :owners , :contact , :string
    add_column :accounts , :name , :string
    add_column :accounts , :contact , :string
  end
end

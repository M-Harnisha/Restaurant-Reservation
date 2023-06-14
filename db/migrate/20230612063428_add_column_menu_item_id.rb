class AddColumnMenuItemId < ActiveRecord::Migration[7.0]
  def change
    add_column :order_items , :menu_id , :string
  end
end

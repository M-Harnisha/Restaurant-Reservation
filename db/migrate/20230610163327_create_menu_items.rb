class CreateMenuItems < ActiveRecord::Migration[7.0]
  def change
    create_table :menu_items do |t|
      t.string :name
      t.integer :quantity
      t.integer :rate

      t.timestamps
    end
  end
end

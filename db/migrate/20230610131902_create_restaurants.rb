class CreateRestaurants < ActiveRecord::Migration[7.0]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.text :address
      t.string :contact
      t.string :city

      t.timestamps
    end
  end
end

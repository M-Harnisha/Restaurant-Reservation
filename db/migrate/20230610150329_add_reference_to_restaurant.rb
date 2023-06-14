class AddReferenceToRestaurant < ActiveRecord::Migration[7.0]
  def change
    add_reference :tables , :restaurant , foreign_key:true
  end
end

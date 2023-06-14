class AddReferenceOrderItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :order_items , :order , foreign_key:true
    
  end
end

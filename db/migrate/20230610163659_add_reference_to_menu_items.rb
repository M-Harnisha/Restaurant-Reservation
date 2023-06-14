class AddReferenceToMenuItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :menu_items , :restaurant , foreign_key:true
  end
end

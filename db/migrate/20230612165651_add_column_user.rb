class AddColumnUser < ActiveRecord::Migration[7.0]
  def change
    add_reference :restaurants, :owner , foreign_key:true
    add_reference :reservations , :user , foreign_key:true
  end
end

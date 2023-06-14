class AddReferenceToTableBooked < ActiveRecord::Migration[7.0]
  def change
    add_reference :table_bookeds , :reservation , foreign_key:true
  end
end

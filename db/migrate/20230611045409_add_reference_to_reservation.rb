class AddReferenceToReservation < ActiveRecord::Migration[7.0]
  def change
    add_reference :reservations ,:restaurant , foreign_key:true
    add_reference :reservations ,:table , foreign_key:true
  end
end

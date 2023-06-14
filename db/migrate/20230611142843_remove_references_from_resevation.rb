class RemoveReferencesFromResevation < ActiveRecord::Migration[7.0]
  def change
    remove_reference :reservations , :table 

  end
end

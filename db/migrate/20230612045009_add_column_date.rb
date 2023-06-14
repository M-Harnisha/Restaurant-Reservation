class AddColumnDate < ActiveRecord::Migration[7.0]
  def change
    remove_column :reservations ,:date ,:datetime
    add_column :reservations , :date , :date
  end
end

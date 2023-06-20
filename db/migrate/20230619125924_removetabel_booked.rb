class RemovetabelBooked < ActiveRecord::Migration[7.0]
  def change
    drop_table :table_bookeds
  end
end

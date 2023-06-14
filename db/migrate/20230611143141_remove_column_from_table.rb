class RemoveColumnFromTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :tables , :booked , :boolean
  end
end

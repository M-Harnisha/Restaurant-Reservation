class CreateJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :tables, :reservations 
  end
end

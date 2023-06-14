class CreateTableBookeds < ActiveRecord::Migration[7.0]
  def change
    create_table :table_bookeds do |t|
      t.string :table_id

      t.timestamps
    end
  end
end

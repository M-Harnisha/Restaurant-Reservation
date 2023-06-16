class AddColumnInAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts , :accountable_id , :integer
    add_column :accounts , :accountable_type , :string  
  end
end

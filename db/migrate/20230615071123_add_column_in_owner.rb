class AddColumnInOwner < ActiveRecord::Migration[7.0]
  def change
    add_column :owners , :food_service_id , :string
  end
end

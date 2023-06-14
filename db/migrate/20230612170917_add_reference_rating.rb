class AddReferenceRating < ActiveRecord::Migration[7.0]
  def change
    add_column :ratings , :value , :integer
    add_column :ratings , :rateable_type , :string
    add_column :ratings , :rateable_id , :string
  end
end

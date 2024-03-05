class CreateTackleLists < ActiveRecord::Migration[6.1]
  def change
    create_table :tackle_lists do |t|
      t.integer :tackle_id, null: false
      t.integer :tackle_item_id, null: false
      t.string :item_name
      t.timestamps
    end
  end
end

class CreateTackleItems < ActiveRecord::Migration[6.1]
  def change
    create_table :tackle_items do |t|
      t.string :name
      t.integer :order
      t.timestamps
    end
  end
end

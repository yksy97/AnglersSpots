class CreateTides < ActiveRecord::Migration[6.1]
  def change
    create_table :tides do |t|
      t.integer :prefecture_code
      t.integer :port_code
      t.string :prefecture_name
      t.string :port_name
      t.timestamps
    end
  end
end

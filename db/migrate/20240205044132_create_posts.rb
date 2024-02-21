class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.text :body
      t.integer :tackle_id
      t.string :location
      t.integer :customer_id
      t.integer :genre_id
      t.timestamps
    end
  end
end

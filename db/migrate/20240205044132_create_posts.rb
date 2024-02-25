class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.integer :tackle_id
      t.string :location
      t.integer :customer_id
      t.string :genre_name
      t.timestamps
    end
  end
end

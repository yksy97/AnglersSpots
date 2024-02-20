class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      # t.string "title"
      t.text :body
      t.integer :rig_id
      t.integer :tackle_id
      t.string :location
      # t.string "rod"
      # t.string "reel"
      # t.string "line"
      # t.string "hook"
      # t.string "bait"
      # t.string "tips"
      t.integer :customer_id
      t.integer :genre_id
      t.timestamps
    end
  end
end

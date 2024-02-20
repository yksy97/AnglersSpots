class CreateRigPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :rig_posts do |t|
      t.integer :rig_id, null: false
      t.integer :post_id, null: false
      t.timestamps
    end
  end
end

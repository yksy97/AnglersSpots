class CreateSpots < ActiveRecord::Migration[6.1]
  def change
    create_table :spots do |t|
      t.string :name
      # 緯度
      t.float :latitude
      # 経度
      t.float :longitude

      t.timestamps
    end
  end
end

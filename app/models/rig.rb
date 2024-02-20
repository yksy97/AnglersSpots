class Rig < ApplicationRecord
  has_many :rig_posts, dependent: :destroy, foreign_key: 'rig_id'
  has_many :posts, through: :rig_posts
  
  # belongs_toの場合
  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end
  # has_manyの場合
  def self.ransackable_associations(auth_object = nil)
    ["posts", "rig_posts"]
  end
end

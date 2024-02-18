class Rig < ApplicationRecord
  has_many :rig_posts, dependent: :destroy, foreign_key: 'rig_id'
  has_many :posts, through: :rig_posts
end

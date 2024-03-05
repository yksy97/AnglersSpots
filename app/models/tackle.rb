class Tackle < ApplicationRecord
  belongs_to :customer
  has_many :posts
  has_many :tackle_items # 項目
  has_many :tackle_lists, dependent: :destroy # 記録
  
  accepts_nested_attributes_for :tackle_lists, reject_if: :all_blank, allow_destroy: true
  
  validates :name, presence: true, uniqueness: { scope: :customer_id, message: "このタックル名はすでに存在します" }

  # def self.ransackable_attributes(auth_object = nil)
  #   ["name", "rod", "reel", "line", "bait"]
  # end
  
  def self.ransackable_associations(auth_object = nil)
    ["posts"]
  end
  
  before_destroy :delete_posts_tackle_id
  
  def delete_posts_tackle_id
    Post.where(tackle_id: self.id).update_all(tackle_id: nil)
  end
end

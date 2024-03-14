class Tackle < ApplicationRecord
  belongs_to :customer
  has_many :posts
  has_many :tackle_items
  has_many :tackle_lists, dependent: :destroy

  accepts_nested_attributes_for :tackle_lists, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["posts"]
  end

  before_destroy :delete_posts_tackle_id

  def delete_posts_tackle_id
    Post.where(tackle_id: self.id).update_all(tackle_id: nil)
  end
end
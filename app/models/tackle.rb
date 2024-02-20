class Tackle < ApplicationRecord
  belongs_to :customer
  has_many :posts
  
  validates :name, presence: true, uniqueness: { scope: :customer_id, message: "このタックル名はすでに存在します" }

  def self.ransackable_attributes(auth_object = nil)
    ["name", "rod", "reel", "line", "bait"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["posts"]
  end

end

class Tackle < ApplicationRecord
  belongs_to :customer
  has_many :posts
  
  validates :name, presence: true, uniqueness: { scope: :customer_id, message: "このタックル名はすでに存在します" }

end

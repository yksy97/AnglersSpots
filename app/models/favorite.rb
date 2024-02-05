class Favorite < ApplicationRecord
  belongs_to :customer
  belongs_to :book
  validates_uniqueness_of :book_id, scope: :customer_id
end
class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "customer"
  belongs_to :followed, class_name: "customer"
end
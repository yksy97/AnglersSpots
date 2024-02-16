class Genre < ApplicationRecord
has_many :posts

validates :name, presence: true, length: { maximum: 50 }

def self.ransackable_attributes(auth_object = nil)
  ["name"]
end

end
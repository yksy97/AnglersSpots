class Genre < ApplicationRecord
has_many :posts

validates :name, presence: true

def self.ransackable_attributes(auth_object = nil)
  ["name"]
end

end
end

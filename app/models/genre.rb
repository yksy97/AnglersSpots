class Genre < ApplicationRecord
  class Genre < ApplicationRecord
  has_many :books
  
  validates :name, presence: true
  
  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end

  end
end

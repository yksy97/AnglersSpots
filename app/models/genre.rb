class Genre < ApplicationRecord
  belongs_to :customer
  validates :name, uniqueness: { scope: :customer_id, case_sensitive: false },
                    presence: true,
                    length: { maximum: 50 }

  before_save :downcase_name

  # belongs_toの場合
  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end

  private

  def downcase_name
    self.name = name.strip.downcase
  end
end
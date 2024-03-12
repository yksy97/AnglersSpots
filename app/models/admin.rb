class Admin < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  GUEST_ADMIN_EMAIL = "guest_admin@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_ADMIN_EMAIL) do |admin|
      admin.password = SecureRandom.urlsafe_base64
    end
  end

  def guest_admin?
    email == GUEST_ADMIN_EMAIL
  end
end
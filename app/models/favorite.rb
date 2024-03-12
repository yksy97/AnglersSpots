class Favorite < ApplicationRecord
  belongs_to :customer
  belongs_to :post
  validates_uniqueness_of :post_id, scope: :customer_id
  has_one :notification, as: :notifiable, dependent: :destroy

  def create_notification
    Notification.create(
    customer_id: post.customer_id,
    notifiable: self,
    read: false
    )
  end
end
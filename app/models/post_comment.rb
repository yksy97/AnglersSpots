class PostComment < ApplicationRecord
  belongs_to :customer
  belongs_to :post
  validates :comment, presence: true
  has_many :notifications, as: :notifiable, dependent: :destroy

# リプライ機能
# 自己参照の関連付け
# 同一のモデル内でレコード同士が互いに参照し合う関係
# 1つのコメントに対して複数のリプライを持つ
  belongs_to :parent, class_name: "PostComment", optional: true
  has_many :replies, class_name: "PostComment", foreign_key: "parent_id", dependent: :destroy

# belongs_toの場合
  def self.ransackable_attributes(auth_object = nil)
    ["comment"]
  end

# コメント通知
 after_create :create_notification

  private

  def create_notification
    Notification.create(
      customer_id: self.post.customer_id,
      notifiable: self,
      read: false
    )
  end
end

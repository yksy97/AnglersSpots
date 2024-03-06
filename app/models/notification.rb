class Notification < ApplicationRecord
  belongs_to :customer
  belongs_to :notifiable, polymorphic: true
  include Rails.application.routes.url_helpers

  def message
    if notifiable_type === "Post"
      "フォローしている#{notifiable.customer.name}さんが#{notifiable.title}を投稿しました"
    else
      "投稿した#{notifiable.post.title}が#{notifiable.customer.name}さんにいいねされました"
    end
  end

  def notifiable_path
    if self.notifiable_type === "Post"
      post_path(notifiable.id)
    else
      customer_path(notifiable.customer.id)
    end
  end
end
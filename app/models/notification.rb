class Notification < ApplicationRecord
  belongs_to :customer
  belongs_to :notifiable, polymorphic: true
  
  include Rails.application.routes.url_helpers
 
  def message
    if notifiable_type === "Book"
      "フォローしている#{notifiable.user.name}さんが#{notifiable.title}を投稿しました"
    else
      "投稿した#{notifiable.book.title}が#{notifiable.user.name}さんにいいねされました"
    end
  end

  def notifiable_path
    if notification.notifiable_type === "Post"
      posts_path(notifiable.id)
    else
      customer_path(notifiable.customer.id)
    end
  end
end

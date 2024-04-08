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



# 「has_one :notification, as: :notifiable, dependent: :destroy」：いいねと通知は１：１だから「has_one」

# 「validates_uniqueness_of :post_id, scope: :customer_id」：１つのPostに対して。同じCustomerが何度もいいねできないように制限する。一意性。
# 「 validates_uniqueness_of」は、指定された属性の値が一意であることを確認する、Railsの機能。「scope」オプションと併せて使用する。
# -Favoriteモデルのインスタンス（特定の投稿に対するいいね）という行為の一異性を、「Customer」という属性（Customer_id:どのCustomerによるいいねかを示す）に依存させるという意味。

# Genreモデルの「validates :name, uniqueness: { scope: :customer_id, case_sensitive: false },」について、
# ここでの「scope: :customer_id」は、各Customerが自分のジャンルを個別に管理するための記述。Genreモデルの重複を禁止する処理を、各Cutomerごとに行うので、AとBのCustomerが同じジャンル名をGenreモデルのデータベースに登録できる。

# 「notifiable: self,」は、ポリモーフィック関連を使用して、どのいいね（Favoriteオブジェクト）が、この通知の原因であるかを指定している。
# -「self」は、create_notificationメソッドを呼び出している現在のFavoriteオブジェクトを指定する。

# 「read: false」は通知がまだ読まれていないこと（未読状態）を示す。これをCustomerが通知を確認後にこのフラグをtureに更新すると、既読状態に
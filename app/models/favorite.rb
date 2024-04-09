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



# 「create_notification」メソッドは、Favoriteインスタンス（いいね）が生成された場合に、それに関連する通知（Notificationオブジェクト）を生成するためのメソッド。

# customer_idには、いいねされた投稿の所有者（post.customer_id）のIDを指定することで、通知の対象者が投稿の所有者であることを明示する。

# 「read: false」は通知がまだ読まれていないこと（未読状態）を示す。これをCustomerが通知を確認後にこのフラグをtureに更新すると、既読状態になる。
# 既読状態の実装

# １：routes.rbに通知を「既読」にするためのアクションに対応するルーティングを設定
# resources :notifications, only: [] do
#   member do
#     patch 'read'
#   end
# end

# ２：notifications_controller.rbにアクションを定義
#   def read
#     notification = Notification.find(params[:id])
#     notification.update(read: true)
#     redirect_to notification_redirect_path(notification)
#   end

# private
#  def notification_redirect_path(notification)
# -各通知に対応する適切なリダイレクト先を設定
# -例えば、いいね通知なら、その投稿ページへのパスを返す。
# root_path
# end

# ３：ビューでリンク設定
# <% @notifications.each do |notification| %>
#   <%= link_to '既読にする', read_notification_path(notification), method: :patch %>
# <% end %>



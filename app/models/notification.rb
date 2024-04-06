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


# 通知機能
# -ポリモーフィック関連とは、あるモデルが複数の異なるモデルと関連付けされるような関係（多様性）。
# -Railsでは、asオプションを使ってポリモーフィック関連を実装する。

# -ポリモーフィック関連によって、「Notification」モデルは、「Post」モデルだけではなく、通知が可能な他の任意のモデル（ex: 「Comment」モデルや「Favorite」モデルなど）とも関連付けることができる。
# -「Notification」モデルと通知されるモデル（「Post」モデル）は１：多の関係になり、通知対象が削除された場合は通知自体が削除される。＝１つの通知は１つの投稿に関連づけられるが、投稿は複数の通知を持つことができる。
# -１つの通知は１つの投稿に関連づけられるが、投稿は複数の通知を持つことができる。

# -上記をコードにすると、
# --「Notification」モデル　：　belongs_to :notifiable, polymorphic: true
# --「Post」モデル　：　has_many :notifications, as: :notifiable, dependent: :destroy
# 補足として、ポリモーフィック関連はデータモデルの設計に柔軟であるが、クエリが複雑になり、アプリのパフォーマンスに影響するので注意する。



# ポリモーフィック関連
# ポリモーフィック関連のメリット
# 柔軟性：共通化したい1つのモデルを複数のモデルに関連づける際に適している
# DB設計の簡素化：「Notification」モデルを「Post」や「Commernt」モデルなどに対して関連付けする必要がない
# 拡張性：今後、通知対象が増えても簡単に関連付けができる

# 「Customer」モデルだけは「Notification」モデルとの関連付けが必要な理由
# この関係付けは「誰がその通知を受けるか」という情報を持つために必要で、各通知がどのCustomerに属しているかを特定する。
# 通知対象は柔軟に関連付けできるが、通知を受け取るCustomerは変わらないので、この関連付けが必要


# 具体的に、
# 「belongs_to :notifiable, polymorphic: true」
# 上記で、ポリモーフィック関連の設定ができ、「Notification」モデルが複数の異なるモデルに関連付けできるようになる。



# 「include Rails.application.routes.url_helpers」
# これはRailsのモデルやその他のクラス内で、RailsのURLヘルパーを使うために必要な記述。＝ モデル内部で「post_pathやcustomer_path」を使うため。
# 「notification」メソッドで通知に関するリソースのURLを動的に生成して、Customerを適切なページに誘導することができる。
# -通知一覧の各通知（例えば、A投稿にBさんがいいねをしました）に表示されているAとBの詳細ページに直接飛ぶことができる。

# 注意点：モデル内でURLヘルパーを使用することは、MVCパターンの原則に反する可能性があるので、今回のような通知機能以外では使わないこと。
# MVCパターンの原則：ビジネスロジックはモデルに、表示やURLに関わるロジックはビューやコントローラーに記述すること



# Rubyでの「＝＝＝」の意味：case equality operator
# クラスやモジュールが特定のオブジェクトに適合するかを判定するのに使ったり、正規表現が文字列に合うかを確認する。
# if文の中では、通常「＝＝＝」ではなく「＝＝」を使いたい（今回は変更）。PFでは「self.notifiable_type」が「Post」と等しいか確認している
# 「＝＝＝」と「＝＝」の違いは、前者が後者より広範（広い範囲）で一致を表す場合に用いる
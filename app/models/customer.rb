class Customer < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  GUEST_CUSTOMER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_CUSTOMER_EMAIL) do |customer|
      customer.password = SecureRandom.urlsafe_base64
      customer.name = "ゲスト"
    end
  end

  def guest_customer?
    email == GUEST_CUSTOMER_EMAIL
  end

  has_many :posts
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :genres
  has_one_attached :image

  # フォロー
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed

  # フォロワー
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # タックル
  has_many :tackles

  # 通知
  has_many :notifications, dependent: :destroy

  def get_image
  if image.attached?
    image
  else
    '/assets/no_image.jpg'
  end
  end

  def follow(other_customer)
    relationships.create(followed_id: other_customer.id) unless self == other_customer
  end

  def unfollow(other_customer)
  relationships.find_by(followed_id: other_customer.id).destroy if following?(other_customer)
  end

  def following?(other_customer)
  followings.include?(other_customer)
  end

end



# ２５行目「has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy」の「class_name: "Relationship",」について
# これは、関連するモデルがRelationshipであると、「明示的」にモデルのクラス名を指定している。
# なぜ明示的に指定するのか。
# -「Customer」モデルが「Relationship」モデルと2種類の異なる関係を持っているから。
# -2種類の異なる関係とは、フォロー「Followings」とフォロワー「Followers」のこと。この２つは、内部的に「Relationship」モデルで表されている。
# -Railsには、この「Followings」と「Followers」の関連から、「Relationship」モデルを直接推測することができないので、明示的に「Relationship」モデルを指定する。

# 要するに、明示していない場合、「Relationship」モデルを介して、フォローしているCustomerの集まりを表現している「has_many :followings」を、Railsは「Followings」モデルだと判断して、
# 存在しないモデルを探してしまう。そこで、「class_name」オプションを使って、Railsに正確なモデルを指定する必要がある。

# ２９行目のフォローワー関係を記述する際も、reverse_of_relationshipsとfollowersという存在しないモデルを探さないように明示的に「Relationship」モデルを指定している。

# ここでの、「has_many :relationships」と「has_many :reverse_of_relationships」は「Relationship」モデルを中間テーブルとして使用していて、
# 「follower_id」を外部キーとして持っている。「follower_id」は、フォローしている、又は、フォローされているCustomer（自分自身）のIDのこと。

# 「Relationship」モデルは中間テーブルとして、２つの「follower_id」の外部キーを持って、どのCustomerがどのCustomerをフォローしているかを記録し、多対多の関係が実現している。

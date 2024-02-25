class Customer < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  # ゲストカスタマー用のメールアドレスを定数として設定
  GUEST_CUSTOMER_EMAIL = "guest@example.com"

  # ゲストカスタマーを見つけるか作成するメソッド
  def self.guest
    find_or_create_by!(email: GUEST_CUSTOMER_EMAIL) do |customer|
      # セキュアなランダムパスワードを生成
      customer.password = SecureRandom.urlsafe_base64
      # 任意の名前を設定（必要に応じて変更可能）
      customer.name = "ゲスト"
      # その他の必要な初期設定があればここに記述
    end
  end

  # ゲストカスタマーかどうかを判定するメソッド
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
  
  # タックルプリセット
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

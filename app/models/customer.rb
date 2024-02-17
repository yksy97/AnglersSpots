class Customer < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :posts
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
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

  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end
  end
end

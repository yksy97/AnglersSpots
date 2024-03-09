class Post < ApplicationRecord
  # 会員
  belongs_to :customer
  # タックル
  belongs_to :tackle, optional: true
  # コメント
  has_many :post_comments, dependent: :destroy
  # いいね
  has_many :favorites, dependent: :destroy
  # 通知
  has_many :notifications, as: :notifiable, dependent: :destroy
  # 釣り方
  has_many :rig_posts, dependent: :destroy
  has_many :rigs, through: :rig_posts
  attr_accessor :rig_list

  validate :validate_genre_presence
  validates :title, presence: true, length: { maximum: 50 }
  validates :body, presence: true, length: { maximum: 500 }
  validates :location, presence: true


  # 投稿のバリデーション
  def validate_genre_presence
    # 既存の魚種が選択されていない、かつ、新規の魚種が空欄の場合
    if genre_name.blank? && new_genre_name.blank?
      errors.add(:base, '既存の魚種を選択するか、新規の魚種名を入力してください')
    end

    # 新規の魚種は、その名前でジャンルが存在するかチェックし、存在しなければ新規ジャンルで作成
    unless new_genre_name.blank?
      new_genre = Genre.find_or_create_by(name: new_genre_name)
      # 新規の魚種をPostに関連付け
      self.genre_name = new_genre.name 
    end
  end
  
  # 新規の魚種
  attr_accessor :new_genre_name

  # いいね
  def favorited_by?(customer)
    favorites.where(customer_id: customer.id).exists?
  end

  # 画像
  has_one_attached :image

  # no_image画像 
  def get_image
    if image.attached?
      image
    else
      'no_image.jpg'
    end
  end

  # 釣り方
  def save_rigs(rigs)
    rig_list = rigs.split(/[[:blank:]]+/)
    current_rigs = self.rigs.pluck(:name)

    old_rigs = current_rigs - rig_list
    new_rigs = rig_list - current_rigs
    old_rigs.each do |old|
      self.rigs.delete Rig.find_by(name: old)
  end

    new_rigs.each do |new|
      new_post_rig = Rig.find_or_create_by(name: new)
      self.rigs << new_post_rig
    end
  end

  after_find :rigs_to_rig_list
  def rigs_to_rig_list
    if self.rigs && self.rigs.any?
      self.rig_list = self.rigs.map{|o| o.name }.join(" ")
    end
  end
  before_update :update_rigs
  def update_rigs
    save_rigs(self.rig_list)
  end

  after_create do
    customer.followers.each do |follower|
      notifications.create(customer_id: follower.id)
    end
  end  

  # 検索機能
  def self.ransackable_attributes(auth_object = nil)
    ["body", "genre_name"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["post_comments", "rig_posts", "rigs", "tackle"]
  end
end
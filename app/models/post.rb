class Post < ApplicationRecord
  belongs_to :customer
  # 「optional: true」は、PostとGenreの関連付け）を任意で行えるようにするオプション
  # 会員が新しい魚で投稿したとき、Genreの指定がない状態でもPostの作成が可能になる
  # ＝ 全てのPostがGenreに属する必要はないので、魚（ジャンル）が未分類のPostも許容される
  belongs_to :genre, optional: true
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one_attached :image
  
  # 通知
  has_many :notifications, as: :notifiable, dependent: :destroy
  
  after_create do
    customer.followers.each do |follower|
      notifications.create(customer_id: follower.id)
    end
  end  
  
  validate :validate_genre_presence
  validates :body, presence: true, length: { maximum: 500 }
  validates :rig, presence: true
  validates :location, presence: true
  
  # 仮想属性（フォームで一時的に使用するための属性）
  # 「new_genre_name」 は、PostモデルのDBに保存される属性ではなく、
  # 会員がフォームに入力した新しい魚を保持するために使用する
  # フォームから受け取った新しい魚は、Postコントローラの createアクション内で
  # Genreモデル(魚種の管理) の新しいレコード作成に使用され、その後この一時的な値は不要となる
  # これにより、会員は新しい魚をシステムに追加できる
  attr_accessor :new_genre_name
  
  def favorited_by?(customer)
    favorites.where(customer_id: customer.id).exists?
  end
  
  private

# 投稿フォーム（public/posts/index）のモデル側のバリデーション
  def validate_genre_presence
    # 既存の魚が選択されていない、かつ新しい魚が空の場合エラーを追加
    if genre_id.blank? && new_genre_name.blank?
      errors.add(:base, '既存の魚種を選択するか、新規の魚種名を入力してください')
    end

    # 新規の魚は、その名前でジャンルが存在するかチェックし、存在しなければ新規ジャンルで作成
    unless new_genre_name.blank?
      new_genre = Genre.find_or_create_by(name: new_genre_name)
      self.genre_id = new_genre.id # 新規作成または見つかったジャンルをPostに関連付ける
    end
  end
	
  def self.search_for(content, method)
    if method == 'perfect'
      Post.where(title: content)
    elsif method == 'forward'
      Post.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      Post.where('title LIKE ?', '%'+content)
    else
      Post.where('title LIKE ?', '%'+content+'%')
    end
  end
  
  def get_image
    if image.attached?
      image
    else
      '/assets/no_image.jpg'
    end
  end
  
  
end

  



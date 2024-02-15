class Post < ApplicationRecord
  belongs_to :customer
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
  
  # validates :title, presence: true
  validates :body, presence: true
  
  # 仮想属性（フォームで一時的に使用するための属性）
  # 「new_genre_name」 は、PostモデルのDBに保存される属性ではありません。
  # この一時的な属性は、ユーザーがフォームに入力した新規魚種名を保持するために使用します。
  # フォームから受け取った新規魚種名は、Postコントローラの createアクション内で
  # Genreモデル(魚種の管理) の新しいレコード作成に使用され、その後この一時的な値は不要となります。
  # これにより、ユーザーは新しい魚種をシステムに追加できます。
  attr_accessor :new_genre_name
  
  def favorited_by?(customer)
    favorites.where(customer_id: customer.id).exists?
  end
	
  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%'+content)
    else
      Book.where('title LIKE ?', '%'+content+'%')
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

  



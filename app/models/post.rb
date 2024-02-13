class Post < ApplicationRecord
  belongs_to :customer
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one_attached :image
  
  validates :title,presence:true
  validates :body,presence:true
  
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
end

 def get_image
  if image.attached?
    image
  else
    '/assets/no_image.jpg'
  end
  end



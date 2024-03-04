class Post < ApplicationRecord
  belongs_to :customer
  # 「optional: true」は、PostとGenreの関連付け）を任意で行えるようにするオプション
  # 会員が新しい魚で投稿したとき、Genreの指定がない状態でもPostの作成が可能になる
  # ＝ 全てのPostがGenreに属する必要はないので、魚（ジャンル）が未分類のPostも許容される
  # 「optional: true」にした場合は、nill guardとして<% if @post.tackle %><% end %>の記述をする
  belongs_to :tackle, optional: true
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one_attached :image
  
  # dependent: :destroyでPostが削除されると同時にPostとRigの関係が削除される
  has_many :rig_posts, dependent: :destroy

  # throughを利用して、rig_postsを通してtagsとの関連付け(中間テーブル)
  #   Post.riggsとすれば、Postに紐付けられたTagの取得が可能
  has_many :rigs, through: :rig_posts
  
  # rigの編集に必要なコールバック
  # 投稿詳細の編集画面において、フォームヘルパーの中でリグの編集を行うには工夫が必要
  # 何もしてないとrig自体がテキストにもならない
  # attr_accessorとattributeは大体同じ働きだが、attributeの方がメンテナンスが高い（けど難しい）
  attr_accessor :rig_list
  
  after_find :rigs_to_rig_list
  def rigs_to_rig_list
    # rails c とbeybug使って、self.rigs.map{|o| o.name }.join(" ")の動作を確認
    if self.rigs && self.rigs.any?
      self.rig_list = self.rigs.map{|o| o.name }.join(" ")
    end
  end
  before_update :update_rigs
  def update_rigs
    save_rigs(self.rig_list)
  end
  
  # 通知
  has_many :notifications, as: :notifiable, dependent: :destroy
  
  after_create do
    customer.followers.each do |follower|
      notifications.create(customer_id: follower.id)
    end
  end  
  
  validate :validate_genre_presence
  validates :title, presence: true, length: { maximum: 50 }
  validates :body, presence: true, length: { maximum: 500 }
  validates :location, presence: true
  
  # 「attr_accessor」
  # 仮想的な属性（フォームで一時的に使用するための属性）
  # データベースやActiveRecordとは関連がない
  # rubyの機能で、オブジェクトのインスタンス変数（今回は「new_genre_name」）のgetterとsetterを自動的に生成する。
  
  # 会員が新しい魚種をフォームに入力したとき、この魚種名（new_genre_name）はPostモデルのインスタンス内で一時的に保持される。
  # フォーム送信後に、Genreモデルで新規魚種がジャンル登録される。
  attr_accessor :new_genre_name

  # バリデーション
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
  
  # いいね
  def favorited_by?(customer)
    favorites.where(customer_id: customer.id).exists?
  end
    
    # no_image画像 
  def get_image
    if image.attached?
      image
    else
      'no_image.jpg'
    end
  end
  
  def save_rigs(rigs)
    # リグをスペース区切りで分割し配列にする
    #   連続した空白も対応するので、最後の“+”がポイント
    rig_list = rigs.split(/[[:blank:]]+/)

    # 自分自身に関連づいたリグを取得する
    current_rigs = self.rigs.pluck(:name)

    # (1) 元々自分に紐付いていたリグと投稿されたリグの差分を抽出
    #   -- 更新時に削除されたリグ
    old_rigs = current_rigs - rig_list

    # (2) 投稿されたリグと元々自分に紐付いていたリグの差分を抽出
    #   -- 新規に追加されたリグ
    new_rigs = rig_list - current_rigs

    # rig_postsテーブルから、(1)のタグを削除
    #   rigsテーブルから該当のタグを探し出して削除する
    old_rigs.each do |old|
      # rig_postsテーブルにあるpost_idとrig_idを削除
      #   後続のfind_byでrig_idを検索
      self.rigs.delete Rig.find_by(name: old)
    end

    # rigsテーブルから(2)のタグを探して、rig_postsテーブルにrig_idを追加する
    new_rigs.each do |new|
      # 条件のレコードを初めの1件を取得し1件もなければ作成する
      # find_or_create_by : https://railsdoc.com/page/find_or_create_by
      new_post_rig = Rig.find_or_create_by(name: new)

      # rig_postsテーブルにpost_idとrig_idを保存
      #   配列追加のようにレコードを渡すことで新規レコード作成が可能
      self.rigs << new_post_rig
    end
  end
  
  def self.ransackable_attributes(auth_object = nil)
    ["body", "genre_name"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["post_comments", "rig_posts", "rigs", "tackle"]
  end


end

  



class Public::FavoritesController < ApplicationController
  before_action :authenticate_customer!

  def index
    @favorites = current_customer.favorites.includes(:post).order(created_at: :desc)
  end

  def create
    post = Post.find(params[:post_id])
    @favorite = current_customer.favorites.new(post_id: post.id)
    @favorite.save

    # modelに記述したメゾットをここで呼び出す。なお、if end構文は1行なら、メゾットの後ろにifを書いてもOK
    @favorite.create_notification if current_customer.id != post.customer_id

    @favorites = current_customer.favorites.includes(:post).order(created_at: :desc)

    respond_to do |format|
      format.html { redirect_to post_path(post) }
      format.js
    end
  end

  def destroy
    post = Post.find(params[:post_id])
    @favorite = current_customer.favorites.find_by(post_id: post.id)
    @favorite.destroy
    @favorites = current_customer.favorites.includes(:post).order(created_at: :desc)
    respond_to do |format|
      format.html { redirect_to post_path(post) }
      format.js
    end
  end
end



# Favoriteモデルで、定義した「create_notification」メソッドを、14行目で条件を付けて呼び出している。
# createアクション＝いいねボタンを押した際に走る処理の中で、現在のログインユーザー（current_customer_id）が、
# -いいねをした投稿の所有者（post.customer_id）ではない場合（！＝）に、「create_notification」メソッドを呼び出す。
# これにより、他のユーザーが自分の投稿にいいねをした際にのみ通知が作成され、自分自身の投稿に対する自分のいいねでは通知は作成されない。

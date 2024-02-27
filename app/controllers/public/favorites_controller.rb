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
      # 同期リクエスト
      format.html { redirect_to post_path(post) }
      # Ajaxリクエスト
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

class Public::FavoritesController < ApplicationController
  before_action :authenticate_customer!
def create
  post = Post.find(params[:post_id])
  @favorite = current_customer.favorites.new(post_id: post.id)
  @favorite.save
  
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
  respond_to do |format|
    format.html { redirect_to post_path(post) }  
    format.js
  end
end
end




class Public::FavoritesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    favorite = @post.favorites.new(customer_id: current_customer.id)
    
    # いいね通知機能
    if favorite.save
      # 既に同じ通知が存在しないか確認
      unless Notification.where(recipient: @post.customer, actor: current_customer, action: 'liked', notifiable: @post).exists?
        Notification.create(recipient: @post.customer, actor: current_customer, action: 'liked', notifiable: @post)
      end
    end

    respond_to do |format|
      # 同期リクエスト
      format.html { redirect_to post_path(@post) }
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




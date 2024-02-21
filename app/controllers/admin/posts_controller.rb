class Admin::PostsController < ApplicationController
  def index
    @posts = Post.where(customer_id: params[:customer_id])
  end
  
  def show
    @post = Post.find(params[:id])
  end
  
  def destroy
    post = Post.find(params[:id]).destroy
    redirect_to admin_customer_posts_path(post.customer)
  end
end

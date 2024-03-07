class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @customer = Customer.find(params[:customer_id])
    @posts = Post.where(customer_id: params[:customer_id]).order(created_at: :desc).page(params[:page]).per(6)
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    post = Post.find(params[:id]).destroy
    redirect_to admin_customer_posts_path(post.customer)
  end
end
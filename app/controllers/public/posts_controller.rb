class Public::PostsController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_correct_customer, only: [:edit, :update, :destroy]

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
    @post_comments = @post.post_comments.order(created_at: :desc)
  end

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).order(created_at: :desc)
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.customer_id = current_customer.id

    if @post.save
      redirect_to posts_path, notice: "投稿が完了しました"
    end
  end

  def genre
    genre = Genre.find(params[:id])
    @posts = genre.posts
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "投稿が更新されました。"
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "投稿が削除されました"
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :rod, :reel, :rod, :line, :bait, :hook, :tips)
  end

  def ensure_correct_customer
    @post = Post.find(params[:id])
    unless @post.customer == current_customer
      redirect_to posts_path, alert: '権限がありません。'
    end
  end
end
